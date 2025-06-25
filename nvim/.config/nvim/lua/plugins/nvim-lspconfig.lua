return {
  'neovim/nvim-lspconfig',
  tag = 'v1.0.0',
  -- Install all required external dependencies
  build = { 'npm install -g vscode-langservers-extracted@4.10.0' },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      'williamboman/mason.nvim',
      commit = 'e2f7f90',
    },
    {
      'williamboman/mason-lspconfig.nvim',
      commit = '43894ad',
    },
    -- Automatically install formatters and other tools
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      commit = 'c5e07b8',
    },

    -- Useful status updates for LSP
    {
      'j-hui/fidget.nvim',
      commit = 'e2a175c',
      opts = {
        notification = {
          window = {
            winblend = 0
          }
        }
      }
    },

    -- Provides additional settings and completions for Neovim's Lua API
    {
      'folke/neodev.nvim',
      commit = '46aa467',
    }
  },
  config = function()
    -- [[ Configure LSP ]]
    --  This function gets run when an LSP connects to a particular buffer.
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

      --Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    -- rounded borders for lsp hover documentation
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded"
      }
    )

    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    require('mason').setup()
    require('mason-lspconfig').setup()

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- LSPs
    local servers = {
      rust_analyzer = {},
      gopls = {},
      ts_ls = {},
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
      csharp_ls = {}, -- requires `dotnet-sdk` to be installed
      pyright = {},
      angularls = {},
      cssls = {},
      asm_lsp = {},
      ['eslint@4.8.0'] = {},
    }

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        }
      end,
    }

    local signs = { Error = "󰅚", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Ensure other tools are installed
    require('mason-tool-installer').setup({
      ensure_installed = {
        'prettier',
        'black',
        'isort',
      },
      run_on_start = true,
    })
  end
}
