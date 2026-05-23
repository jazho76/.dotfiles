return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      python = { 'isort', 'black' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      markdown = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      graphql = { 'prettier' },
      go = { 'gofmt' },
    },
    formatters = {
      prettier = {
        prepend_args = function(_, ctx)
          if vim.bo[ctx.buf].filetype == 'scss' then
            return { '--parser', 'scss' }
          end
          return {}
        end,
      },
    },
  },
}
