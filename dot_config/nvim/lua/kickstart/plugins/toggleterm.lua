return {
  {
    'akinsho/toggleterm.nvim',
    name = 'toggleterm',
    version = '*',
    config = function()
      require('toggleterm').setup {
        persist_mode = false,
        start_in_insert = true,
        direction = 'horizontal',
        open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
        float_opts = {
          border = 'curved',
        },
      }
    end,
  },
}
