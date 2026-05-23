return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
    }
  },
  config = function()
    require('nvim-tree').setup {
      update_focused_file = {
        enable = true,
      },
      view = {
        width = '20%',
      },
      actions = {
        open_file = {
          quit_on_open = true
        }
      }
    }

    vim.keymap.set('n', '<A-e>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end,
}
