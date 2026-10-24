local M = {}
local Source = {}

local function in_frontmatter_tags_list(bufnr, lnum)
  local ok, Note = pcall(require, 'obsidian.note')
  if not ok then
    return false
  end
  local note = Note.from_buffer(bufnr)
  if not note or not note.frontmatter_end_line then
    return false
  end
  if lnum < 1 or lnum > note.frontmatter_end_line then
    return false
  end

  for row = lnum, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ''
    local key = line:match '^([%w_]+):%s*$'
    if key then
      return key == 'tags'
    end
    if not line:match '^%s*%-' and not line:match '^%s*$' then
      return false
    end
  end
  return false
end

function Source.new()
  return setmetatable({}, { __index = Source })
end

function Source:is_available()
  if vim.bo.filetype ~= 'markdown' then
    return false
  end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  return in_frontmatter_tags_list(vim.api.nvim_get_current_buf(), row)
end

function Source:get_keyword_pattern()
  return [[\%([[:alnum:]_-]\)\+]]
end

function Source:complete(_, callback)
  local search = require 'obsidian.search'
  search.find_tags_async('', function(locs)
    local seen, items = {}, {}
    for _, loc in ipairs(locs or {}) do
      if loc.tag and not seen[loc.tag] then
        seen[loc.tag] = true
        table.insert(items, {
          label = loc.tag,
          kind = vim.lsp.protocol.CompletionItemKind.Keyword,
          cmp = {
            kind_text = 'Tag',
            kind_hl_group = 'CmpItemKindKeyword',
          },
        })
      end
    end
    callback { items = items, isIncomplete = false }
  end)
end

function M.setup()
  require('cmp').register_source('obsidian_frontmatter_tags', Source.new())
end

return M
