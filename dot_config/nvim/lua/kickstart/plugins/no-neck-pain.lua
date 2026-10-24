return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    require('no-neck-pain').setup { width = 140 }
    vim.keymap.set('n', '<leader>np', '<CMD>NoNeckPain<CR>', { desc = '[N]o [N]eck [P]ain toggle' })
  end,
}
