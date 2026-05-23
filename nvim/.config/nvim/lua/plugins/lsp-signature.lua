return {
  -- For function signatures hints through LSP
  'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
  opts = {},
  config = function()
    require 'lsp_signature'.setup({
      hint_prefix = ''
    })
  end
}
