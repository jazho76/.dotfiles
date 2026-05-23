return {
  'klen/nvim-test',
    config = function()
    require('nvim-test').setup({
      runners = {
        cs = "nvim-test.runners.dotnet",
        go = "nvim-test.runners.go-test",
        haskell = "nvim-test.runners.hspec",
        javascriptreact = "nvim-test.runners.mocha",
        javascript = "nvim-test.runners.mocha",
        lua = "nvim-test.runners.busted",
        python = "nvim-test.runners.pytest",
        ruby = "nvim-test.runners.rspec",
        rust = "nvim-test.runners.cargo-test",
        typescript = "nvim-test.runners.mocha",
        typescriptreact = "nvim-test.runners.mocha",
      },
    });

    vim.keymap.set('n', '<leader>Tr', ':TestNearest<CR>', { desc = 'Run nearest test' })
  end
}
