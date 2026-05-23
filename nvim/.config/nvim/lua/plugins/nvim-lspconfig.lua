return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'williamboman/mason.nvim',
    },
    {
      'williamboman/mason-lspconfig.nvim',
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('<leader>lr', '<cmd>LspRestart<CR>', '[R]estart')
      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch Document [S]ymbols')
      nmap('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch Workspace [S]ymbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        local ok, conform = pcall(require, 'conform')
        if ok then
          conform.format({ bufnr = bufnr, lsp_format = 'fallback' })
          return
        end

        vim.lsp.buf.format()
      end, { desc = 'Format current buffer' })
    end

    vim.o.winborder = 'rounded'

    require('mason').setup()

    local servers = {
      rust_analyzer = {},
      gopls = {},
      ts_ls = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      csharp_ls = {},
      pyright = {},
      angularls = {},
      cssls = {},
      asm_lsp = {},
      eslint = {},
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local mason_lspconfig = require('mason-lspconfig')
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = false,
    })

    for server_name, server_config in pairs(servers) do
      local config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        on_attach = on_attach,
      }, server_config)

      vim.lsp.config(server_name, config)
      vim.lsp.enable(server_name)
    end

    local signs = { Error = '󰅚', Warn = '', Hint = '', Info = '' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    require('mason-tool-installer').setup({
      ensure_installed = {
        'prettier',
        'black',
        'isort',
        'delve',
      },
      run_on_start = true,
    })
  end,
}
