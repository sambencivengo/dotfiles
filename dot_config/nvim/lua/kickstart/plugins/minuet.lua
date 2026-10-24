return {
  'milanglacier/minuet-ai.nvim',
  config = function()
    require('minuet').setup {
      provider = 'copilot', -- or 'openai' if using GPT
      completion = {
        frontend = 'virtual_text', -- inline suggestions
        accept_keymap = '<C-l>', -- press Ctrl+l to accept inline suggestion
        dismiss_keymap = '<C-e>', -- cancel suggestion
      },
    }
  end,
}
