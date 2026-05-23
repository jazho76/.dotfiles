return {
  'NvChad/nvim-colorizer.lua',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    filetypes = {
      'css',
      'scss',
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
    },
    user_default_options = {
      names = false,
      tailwind = true,
    },
  },
}
