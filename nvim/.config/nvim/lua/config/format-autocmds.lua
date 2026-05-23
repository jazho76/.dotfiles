-- [[ Auto format on save ]]
_G.autoformat_enabled = true

function _G.toggle_autoformat()
  _G.autoformat_enabled = not _G.autoformat_enabled
  local status = _G.autoformat_enabled and 'enabled' or 'disabled'
  vim.notify('Autoformatting is ' .. status, vim.log.levels.INFO, { title = 'Toggle Autoformat' })
end

vim.keymap.set('n', '<Leader>tf', _G.toggle_autoformat, { desc = '[T]oggle Auto[f]ormat' })

local format_group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = format_group,
  pattern = {
    '*.py',
    '*.js',
    '*.ts',
    '*.mjs',
    '*.mts',
    '*.jsx',
    '*.tsx',
    '*.go',
    '*.css',
    '*.scss',
    '*.html',
    '*.htm',
    '*.md',
    '*.json',
    '*.yml',
    '*.yaml',
    '*.graphql',
    '*.gql',
  },
  callback = function(args)
    if not _G.autoformat_enabled then
      return
    end

    local ok, conform = pcall(require, 'conform')
    if not ok then
      return
    end

    conform.format({ bufnr = args.buf, lsp_format = 'fallback', timeout_ms = 3000 })
  end,
})
