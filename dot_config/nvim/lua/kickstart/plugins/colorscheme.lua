return {
  {
    'metalelf0/base16-black-metal-scheme',
    lazy = false,
    priority = 1000,
    config = function()
      --vim.cmd.colorscheme 'base16-black-metal'
      -- or pick a variant:
      -- vim.cmd.colorscheme 'base16-black-metal-bathory'
      -- vim.cmd.colorscheme 'base16-black-metal-burzum'
      -- vim.cmd.colorscheme 'base16-black-metal-dark-funeral'
      -- vim.cmd.colorscheme 'base16-black-metal-gorgoroth'
      -- vim.cmd.colorscheme 'base16-black-metal-immortal'
      -- vim.cmd.colorscheme 'base16-black-metal-khold'
      -- vim.cmd.colorscheme 'base16-black-metal-marduk'
      -- vim.cmd.colorscheme 'base16-black-metal-mayhem'
      -- vim.cmd.colorscheme 'base16-black-metal-nile'
      -- vim.cmd.colorscheme 'base16-black-metal-venom'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('kanagawa').setup {
        transparent = false,
        globalStatus = true,
        foreground = 'saturated', -- "default" or "saturated" (can also be a table like background)
        overrides = function(colors) -- add/modify highlights
          local theme = colors.theme
          return {

            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

            -- Telescope: remove border/shadow so it blends with transparent floats
            TelescopeBorder = { bg = 'none' },
            TelescopeTitle = { bg = 'none' },
            TelescopeNormal = { bg = 'none' },
            TelescopePreviewBorder = { bg = 'none' },
            TelescopeResultsBorder = { bg = 'none' },
            TelescopePromptBorder = { bg = 'none' },

            -- LSP hover / signature help and nvim-cmp documentation popups
            LspInfoFloat = { bg = 'none' },
            LspInfoBorder = { bg = 'none' },
            CmpDocumentation = { bg = 'none' },
            CmpDocumentationBorder = { bg = 'none' },
          }
        end,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }

      --vim.opt.fillchars:append { eob = '~' }
      --vim.cmd.highlight 'EndOfBuffer guifg=#5c5c5c guibg=NONE'
      --vim.cmd 'highlight TelescopeBorder guibg=none'
      --vim.cmd 'highlight TelescopeTitle guibg=none'
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })

      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },

  {
    'oskarnurm/koda.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- require("koda").setup({ transparent = true })
      --vim.cmd 'colorscheme koda'
    end,
  },
  {
    'webhooked/kanso.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanso').setup {
        bold = true, -- enable bold fonts
        italics = true, -- enable italics
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = {},
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        --background = { -- map the value of 'background' option to a theme
        --  dark = 'ink', -- try "zen", "mist" or "pearl" !
        --  light = 'ink', -- try "zen", "mist" or "pearl" !
        --},
        foreground = 'default', -- "default" or "saturated" (can also be a table like background)
      }
      --vim.cmd.colorscheme 'kanso-ink'

      -- Apply Copilot highlight *only* inside ColorScheme autocmd
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#6a6a6a', italic = true })
          vim.api.nvim_set_hl(0, 'CopilotSuggestionWord', { fg = '#6a6a6a', italic = true })
          vim.api.nvim_set_hl(0, 'CopilotSuggestionLine', { fg = '#6a6a6a', italic = true })
        end,
      })
    end,
  },
  {
    -- lua/plugins/rose-pine.lua
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      -- vim.cmd 'colorscheme rose-pine'
    end,
  },
  {
    'serhez/teide.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'vague-theme/vague.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require('vague').setup {
        -- optional configuration here
      }
      -- vim.cmd 'colorscheme vague'
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#6a6a6a', bg = 'NONE' })
        end,
      })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#6a6a6a', bg = 'NONE' })
    end,
  },
}
