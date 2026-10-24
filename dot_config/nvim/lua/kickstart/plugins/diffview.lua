return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewRefresh',
    'DiffviewFileHistory',
  },
  keys = {
    {
      '<leader>dv',
      function()
        local lib = require 'diffview.lib'
        if lib.get_current_view() then
          vim.cmd 'DiffviewClose'
        else
          vim.cmd 'DiffviewOpen'
        end
      end,
      desc = '[D]iff[v]iew: toggle (vs index)',
    },
    { '<leader>dV', '<cmd>DiffviewOpen HEAD<cr>', desc = '[D]iff[V]iew: open vs HEAD' },
    { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = '[D]iffview: [c]lose' },
    { '<leader>dt', '<cmd>DiffviewToggleFiles<cr>', desc = '[D]iffview: [t]oggle file panel' },
    { '<leader>dH', '<cmd>DiffviewFileHistory<cr>', desc = '[D]iffview: repo file [H]istory' },
    { '<leader>df', '<cmd>DiffviewFileHistory %<cr>', desc = '[D]iffview: current [f]ile history' },
  },
  opts = function()
    local actions = require 'diffview.actions'
    return {
      view = {
        default = { layout = 'diff2_horizontal' },
        merge_tool = { layout = 'diff4_mixed' },
      },
      file_panel = {
        listing_style = 'tree',
        position = 'left',
        width = 35,
      },
      keymaps = {
        view = {
          { 'n', '<leader>co', actions.conflict_choose 'ours', { desc = 'Conflict: choose [o]urs' } },
          { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Conflict: choose [t]heirs' } },
          { 'n', '<leader>cb', actions.conflict_choose 'all', { desc = 'Conflict: choose [b]oth' } },
          { 'n', '<leader>cn', actions.conflict_choose 'none', { desc = 'Conflict: choose [n]one' } },
          { 'n', '<leader>cO', actions.conflict_choose_all 'ours', { desc = 'Conflict: choose [O]urs (all)' } },
          { 'n', '<leader>cT', actions.conflict_choose_all 'theirs', { desc = 'Conflict: choose [T]heirs (all)' } },
          { 'n', '<leader>cB', actions.conflict_choose_all 'all', { desc = 'Conflict: choose [B]oth (all)' } },
          { 'n', '<leader>cN', actions.conflict_choose_all 'none', { desc = 'Conflict: choose [N]one (all)' } },
        },
        diff_view = {
          { 'n', '<leader>hs', actions.toggle_stage_entry, { desc = '[H]unk: [s]tage/unstage entry' } },
          { 'n', '<leader>hS', actions.stage_all, { desc = '[H]unk: [S]tage all' } },
          { 'n', '<leader>hU', actions.unstage_all, { desc = '[H]unk: [U]nstage all' } },
        },
        file_panel = {
          { 'n', '<leader>hs', actions.toggle_stage_entry, { desc = '[H]unk: [s]tage/unstage entry' } },
          { 'n', '<leader>hS', actions.stage_all, { desc = '[H]unk: [S]tage all' } },
          { 'n', '<leader>hU', actions.unstage_all, { desc = '[H]unk: [U]nstage all' } },
          { 'n', '<leader>co', actions.conflict_choose 'ours', { desc = 'Conflict: choose [o]urs' } },
          { 'n', '<leader>ct', actions.conflict_choose 'theirs', { desc = 'Conflict: choose [t]heirs' } },
          { 'n', '<leader>cb', actions.conflict_choose 'all', { desc = 'Conflict: choose [b]oth' } },
          { 'n', '<leader>cn', actions.conflict_choose 'none', { desc = 'Conflict: choose [n]one' } },
        },
      },
    }
  end,
}
