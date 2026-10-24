return {
  'monkoose/neocodeium',
  event = 'VeryLazy',
  config = function()
    local neocodeium = require 'neocodeium'
    local cmds = require 'neocodeium.commands'

    neocodeium.setup {
      enable = false, -- start with NeoCodeium disabled (server won't run)
    }
    vim.keymap.set('i', '<A-f>', function()
      require('neocodeium').accept()
    end)
    vim.keymap.set('i', '<A-w>', function()
      require('neocodeium').accept_word()
    end)
    vim.keymap.set('i', '<A-a>', function()
      require('neocodeium').accept_line()
    end)
    vim.keymap.set('i', '<A-e>', function()
      require('neocodeium').cycle_or_complete()
    end)
    vim.keymap.set('i', '<A-r>', function()
      require('neocodeium').cycle_or_complete(-1)
    end)
    vim.keymap.set('i', '<A-c>', function()
      require('neocodeium').clear()
    end)

    -- Helper: print/log status
    local function log(msg)
      vim.notify('[NeoCodeium] ' .. msg, vim.log.levels.INFO)
    end

    -- Toggle globally on/off, fully stopping server
    vim.keymap.set('n', '<leader>cn', function()
      local _status, server_status = neocodeium.get_status()
      -- server_status: 0 = running, 1 = connecting, 2 = off
      if server_status == 0 or server_status == 1 then
        -- disable completions and stop server
        cmds.disable(true)
        log 'Disabled and stopped server'
      else
        -- enable plugin (which also connects server)
        cmds.enable()
        log 'Enabled (server starting)'
      end
    end, { desc = 'Toggle NeoCodeium (full stop/start)' })

    -- Optionally, you can autocmd on server stop to log
    vim.api.nvim_create_autocmd('User', {
      pattern = 'NeoCodeiumServerStopped',
      callback = function()
        log 'Server has stopped (User event)'
      end,
    })
    -- 🎨 NeoCodeium highlight groups
    vim.cmd [[
  hi NeoCodeiumSuggestion guifg=#808080 ctermfg=246
  hi NeoCodeiumLabel guifg=#ffffff guibg=#5f87af ctermfg=15 ctermbg=66 gui=reverse
  hi NeoCodeiumSingleLineLabel guifg=#808080 gui=bold ctermfg=246 cterm=bold
]]
  end,
}
