return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gg', ':G | only<CR>', { desc = '[G]it Fu[g]itive' })
  end
}
