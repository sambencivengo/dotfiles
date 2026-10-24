return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp', -- for completion
    },
    keys = {
      -- Core navigation and search
      { '<leader>oo', '<cmd>Obsidian open<cr>', desc = 'Open note in Obsidian app' },
      { '<leader>of', '<cmd>Obsidian quick_switch<cr>', desc = 'Quick switch to note' },
      { '<leader>os', '<cmd>Obsidian search<cr>', desc = 'Search notes' },
      { '<leader>ot', '<cmd>Obsidian tags<cr>', desc = 'Search by tags' },

      -- Note creation
      { '<leader>on', '<cmd>Obsidian new<cr>', desc = 'Create new note' },
      { '<leader>oT', '<cmd>Obsidian template<cr>', desc = 'Insert template' },

      -- Daily notes
      { '<leader>od', '<cmd>Obsidian today<cr>', desc = "Open today's daily note" },
      { '<leader>oy', '<cmd>Obsidian yesterday<cr>', desc = "Open yesterday's daily note" },
      { '<leader>om', '<cmd>Obsidian tomorrow<cr>', desc = "Open tomorrow's daily note" },

      -- Links and structure
      { '<leader>ol', '<cmd>Obsidian links<cr>', desc = 'Show all links in note' },
      { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = 'Show backlinks' },
      { '<leader>og', '<cmd>Obsidian follow_link<cr>', desc = 'Follow link under cursor' },

      -- Utilities
      { '<leader>oc', '<cmd>Obsidian toggle_checkbox<cr>', desc = 'Toggle checkbox' },
      { '<leader>op', '<cmd>Obsidian paste_img<cr>', desc = 'Paste image' },
      { '<leader>or', '<cmd>Obsidian rename<cr>', desc = 'Rename note' },
      { '<leader>ow', '<cmd>Obsidian workspace<cr>', desc = 'Switch workspace' },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = 'personal',
          path = '~/vaults/master',
        },
      },

      -- Completion is provided by obsidian.nvim's built-in LSP server (obsidian-ls),
      -- which nvim-cmp picks up through its `nvim_lsp` source
      completion = {
        min_chars = 2,
      },

      new_notes_location = 'notes_subdir',
      link = { style = 'wiki' },
      search = {
        sort_by = 'modified',
        sort_reversed = true,
      },

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = '/Rotabull/dailies',
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = '%Y_%m_%d',
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = '%B %-d, %Y',
        -- Optional, default tags to add to each new daily note created.
        default_tags = { 'daily-notes' },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },

      -- Templates configuration (recommended)
      templates = {
        folder = 'templates',
        date_format = '%Y_%m_%d',
        time_format = '%H:%M',
      },

      -- Attachments configuration (recommended)
      attachments = {
        folder = 'assets/imgs',
      },

      -- Enhanced picker configuration
      picker = {
        name = 'telescope.nvim',
        note_mappings = {
          new = '<C-x>',
          insert_link = '<C-l>',
        },
        tag_mappings = {
          tag_note = '<C-x>',
          insert_tag = '<C-l>',
        },
      },

      -- Disable UI features to prioritize render-markdown
      ui = {
        enable = false, -- Disabled to avoid conflicts with render-markdown
      },
    },
    config = function(_, opts)
      require('obsidian').setup(opts)

      require('custom.cmp_obsidian_frontmatter_tags').setup()

      vim.api.nvim_create_autocmd('User', {
        pattern = 'ObsidianNoteEnter',
        callback = function(args)
          local actions = require 'obsidian.actions'
          vim.keymap.set('n', '<cr>', actions.smart_action, { buffer = args.buf, expr = true, desc = 'Obsidian smart action' })
          vim.keymap.set('n', '<leader>ch', '<cmd>Obsidian toggle_checkbox<cr>', { buffer = args.buf, desc = 'Toggle checkbox' })
        end,
      })

      -- Set up Obsidian tag highlighting
      local function setup_obsidian_highlights()
        -- Subtle but noticeable tag highlighting using colorscheme variables
        vim.api.nvim_set_hl(0, 'ObsidianTag', { link = 'Identifier', italic = true })
        vim.api.nvim_set_hl(0, 'ObsidianTagText', { link = 'Identifier', italic = true })
      end

      -- Apply highlights immediately and on colorscheme changes
      setup_obsidian_highlights()

      -- Re-apply highlights when colorscheme changes to maintain dynamic theming
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = setup_obsidian_highlights,
        desc = 'Update Obsidian tag highlights on colorscheme change',
      })

      -- Apply tag highlighting only to markdown files inside the Obsidian vault
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local vault_path = vim.fn.expand '~/vaults/master'
          local file_path = vim.fn.expand '%:p'
          -- Only highlight tags if the file is inside the Obsidian vault
          if file_path:find(vault_path, 1, true) then
            vim.fn.matchadd('ObsidianTag', '#[a-zA-Z0-9_-]\\+')
          end
        end,
        desc = 'Highlight Obsidian tags in markdown files inside vault',
      })
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    ft = { 'markdown' },
    opts = {
      enabled = true,
      max_file_size = 5.0, -- MB
      render_modes = { 'n', 'c', 't' },
      anti_conceal = {
        enabled = true,
        above = 0,
        below = 0,
      },
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '█ ', '██ ', '███ ', '████ ', '█████ ', '██████ ' },
        signs = { '󰫎 ' },
        width = 'block',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = true,
        above = '▄',
        below = '▀',
        -- backgrounds = {
        --   'RenderMarkdownH1Bg',
        --   'RenderMarkdownH2Bg',
        --   'RenderMarkdownH3Bg',
        --   'RenderMarkdownH4Bg',
        --   'RenderMarkdownH5Bg',
        --   'RenderMarkdownH6Bg',
        -- },
        -- foregrounds = {
        --   'RenderMarkdownH1',
        --   'RenderMarkdownH2',
        --   'RenderMarkdownH3',
        --   'RenderMarkdownH4',
        --   'RenderMarkdownH5',
        --   'RenderMarkdownH6',
        -- },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        disable_background = { 'diff' },
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      dash = {
        enabled = true,
        icon = '─',
        width = 'full',
        highlight = 'RenderMarkdownDash',
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
        ordered_icons = function(context)
          local value = vim.trim(context.value)
          local index = tonumber(value:sub(1, #value - 1))
          return ('%d.'):format(index > 1 and index or context.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
        highlight_ordered = 'RenderMarkdownOrderedBullet',
      },
      checkbox = {
        enabled = true,
        position = 'inline',
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
        custom = {
          todo = {
            raw = '[-]',
            rendered = '󰥔 ',
            highlight = 'RenderMarkdownTodo',
          },
          important = {
            raw = '[!]',
            rendered = '󰀪 ',
            highlight = 'RenderMarkdownImportant',
          },
          arrow = {
            raw = '[>]',
            rendered = '󰁔 ',
            highlight = 'RenderMarkdownArrow',
          },
          tilde = {
            raw = '[~]',
            rendered = '󰰱 ',
            highlight = 'RenderMarkdownTilde',
          },
        },
      },
      quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = false,
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        preset = 'none',
        style = 'full',
        cell = 'padded',
        alignment_indicator = '━',
        border = {
          '┌',
          '┬',
          '┐',
          '├',
          '┼',
          '┤',
          '└',
          '┴',
          '┘',
          '│',
          '─',
        },
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
      },
      link = {
        enabled = true,
        image = '󰥶 ',
        email = '󰀓 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        custom = {
          web = { pattern = '^http[s]?://', icon = '󰖟 ' },
        },
      },
      sign = {
        enabled = true,
        highlight = 'RenderMarkdownSign',
      },
      overrides = {
        buftype = {
          -- LSP hover / signature popups: drop the code block background,
          -- language label, and fence lines so content sits flush in the float
          nofile = {
            render_modes = true,
            sign = { enabled = false },
            code = {
              language = false,
              disable_background = true,
              border = 'hide',
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      -- Only add colors for bullets, checkboxes, and list items - keep everything else natural
      -- Use theme colors instead of hardcoded hex values
      vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { link = 'Constant', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownOrderedBullet', { link = 'Number', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownUnchecked', { link = 'Type', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownChecked', { link = 'Special', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownTodo', { link = 'Function', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownImportant', { link = 'Keyword', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownArrow', { link = 'Type', bold = true })
      vim.api.nvim_set_hl(0, 'RenderMarkdownTilde', { link = 'String', bold = true })

      -- Obsidian tag highlighting (subtle but noticeable)
      vim.api.nvim_set_hl(0, 'ObsidianTag', { link = 'Identifier', italic = true })
      vim.api.nvim_set_hl(0, 'ObsidianTagText', { link = 'Identifier', italic = true })

      -- Debug function
      vim.keymap.set('n', '<leader>rd', function()
        require('render-markdown').debug()
      end, { desc = 'Debug render-markdown' })
    end,
  },
}
