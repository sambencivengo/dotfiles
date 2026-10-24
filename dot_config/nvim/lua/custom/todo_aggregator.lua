-- Master TODO aggregation for the Obsidian vault.
--
-- Drop a TODO block into any note with <leader>Ti:
--
--     # TODO:
--     - [ ]
--     <!-- /todo -->
--
-- Every checkbox between the `# TODO:` heading and the `<!-- /todo -->` marker is
-- harvested and mirrored into the master file (Rotabull/todo.md) on save, grouped by
-- source note with an Obsidian wikilink back to it. Source notes are the source of
-- truth; the aggregated region in the master file is regenerated each sync.

local M = {}

local config = {
  vault = vim.fn.expand '~/vaults/master',
  master = vim.fn.expand '~/vaults/master/Rotabull/todo.md',
  roots = { 'Rotabull/dailies', 'Rotabull/shortcut_tickets' },
}

local REGION_START = '<!-- aggregated:start -->'
local REGION_END = '<!-- aggregated:end -->'

-- Parse a list of lines into TODO blocks. Each block is a list of checkbox items:
--   { mark = 'x'|' '|'-'|..., checked = bool, text = string, indent = number }
-- Blocks open on a `# TODO:` heading and close on `<!-- /todo -->`. Fenced code is
-- skipped, and an unterminated block (no closing marker) is dropped.
local function parse_todo_blocks(lines)
  local blocks, cur, in_block, in_fence = {}, nil, false, false

  for _, line in ipairs(lines) do
    if line:match '^%s*```' or line:match '^%s*~~~' then
      in_fence = not in_fence
    elseif in_fence then
      -- ignore everything inside fenced code
    elseif line:match '^%s*<!%-%-%s*/todo%s*%-%->%s*$' then
      if cur and #cur > 0 then
        table.insert(blocks, cur)
      end
      cur, in_block = nil, false
    elseif line:match '^#+%s*TODO:' then
      cur, in_block = {}, true
    elseif in_block then
      local indent, mark, text = line:match '^(%s*)%- %[([ xX%-!>~])%]%s?(.*)$'
      if mark then
        text = (text or ''):gsub('%s+$', '')
        local checked = mark:lower() == 'x'
        -- skip the empty placeholder checkbox from a freshly-inserted template
        if not (text == '' and not checked) then
          table.insert(cur, {
            mark = mark,
            checked = checked,
            text = text,
            indent = #indent,
          })
        end
      end
    end
  end

  return blocks
end

-- Build the body lines for the managed region, grouped by source file.
local function build_body(files, blocks_by_file)
  local body = {}
  for _, file in ipairs(files) do
    local blocks = blocks_by_file[file]
    local stem = vim.fn.fnamemodify(file, ':t:r')
    table.insert(body, '')
    table.insert(body, '### [[' .. stem .. ']]')
    for _, block in ipairs(blocks) do
      for _, item in ipairs(block) do
        table.insert(body, string.rep(' ', item.indent) .. '- [' .. item.mark .. '] ' .. item.text)
      end
    end
  end
  return body
end

-- Replace the managed region in the master file with `body`, preserving everything
-- outside it. Appends a fresh region at EOF if no markers exist yet.
local function write_managed_region(master_path, body)
  local lines = vim.fn.filereadable(master_path) == 1 and vim.fn.readfile(master_path) or {}

  local s, e
  for i, l in ipairs(lines) do
    if not s and l:match 'aggregated:start' then
      s = i
    elseif s and l:match 'aggregated:end' then
      e = i
      break
    end
  end

  local out = {}
  if s and e and e > s then
    for i = 1, s do
      table.insert(out, lines[i])
    end
    vim.list_extend(out, body)
    for i = e, #lines do
      table.insert(out, lines[i])
    end
  else
    vim.list_extend(out, lines)
    table.insert(out, '')
    table.insert(out, REGION_START)
    vim.list_extend(out, body)
    table.insert(out, REGION_END)
  end

  vim.fn.writefile(out, master_path)
end

-- Rebuild the master file's aggregated region from all tracked notes.
function M.sync_all()
  local files, blocks_by_file = {}, {}

  for _, rel in ipairs(config.roots) do
    local dir = config.vault .. '/' .. rel
    for _, file in ipairs(vim.fn.globpath(dir, '**/*.md', false, true)) do
      local blocks = parse_todo_blocks(vim.fn.readfile(file))
      if #blocks > 0 then
        table.insert(files, file)
        blocks_by_file[file] = blocks
      end
    end
  end

  table.sort(files)
  write_managed_region(config.master, build_body(files, blocks_by_file))

  -- reload the master if it happens to be open in a buffer
  vim.schedule(function()
    pcall(vim.cmd, 'checktime')
  end)
end

-- Insert a TODO block template at the cursor and start editing the empty checkbox.
function M.insert_block()
  vim.api.nvim_put({ '# TODO:', '- [ ] ', '<!-- /todo -->' }, 'l', true, true)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  -- cursor lands on the last inserted line; step back to the `- [ ] ` line
  vim.api.nvim_win_set_cursor(0, { row - 1, 0 })
  vim.cmd 'startinsert!'
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  vim.keymap.set('n', '<leader>Ti', M.insert_block, { desc = '[T]odo [I]nsert block' })
  vim.keymap.set('n', '<leader>Ts', M.sync_all, { desc = '[T]odo [S]ync master' })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('todo-aggregator', { clear = true }),
    pattern = {
      config.vault .. '/Rotabull/dailies/*.md',
      config.vault .. '/Rotabull/shortcut_tickets/**/*.md',
    },
    callback = function(args)
      -- never harvest the master file itself
      if vim.fn.fnamemodify(args.file, ':p') == vim.fn.fnamemodify(config.master, ':p') then
        return
      end
      M.sync_all()
    end,
    desc = 'Aggregate TODOs into master todo.md on save',
  })
end

return M
