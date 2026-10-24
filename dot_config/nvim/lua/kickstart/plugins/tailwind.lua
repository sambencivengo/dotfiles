return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
  },
  opts = {
    -- Don't let the plugin start tailwindcss through the deprecated require('lspconfig') API;
    -- the server is configured with vim.lsp.config in init.lua instead.
    -- Color hints still work through the plugin's LspAttach autocmd.
    server = { override = false },
  },
}
