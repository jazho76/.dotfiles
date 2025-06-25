return {
  'nvim-treesitter/nvim-treesitter',
  commit = '7930b5f',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    commit = 'ad8f0a4',
  },
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]]
    -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
    vim.defer_fn(function()
      require('nvim-treesitter.configs').setup {

        -- Languages installed for treesitter
        ensure_installed = {
          'c',
          'cpp',
          'go',
          'lua',
          'python',
          'rust',
          'tsx',
          'javascript',
          'typescript',
          'vimdoc',
          'vim',
          'bash',
          'graphql',
          'asm'
        },

        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ar'] = '@parameter.outer',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['ak'] = '@assignment.lhs',
              ['ik'] = '@assignment.lhs',
              ['av'] = '@assignment.rhs',
              ['iv'] = '@assignment.rhs',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']a'] = '@parameter.inner',
              [']b'] = '@block.inner',
              [']f'] = '@function.outer',
              [']k'] = '@assignment.lhs',
              [']v'] = '@assignment.rhs',
            },
            goto_next_end = {
              [']A'] = '@parameter.inner',
              [']B'] = '@block.inner',
              [']F'] = '@function.outer',
              [']K'] = '@assignment.lhs',
              [']V'] = '@assignment.rhs',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[b'] = '@block.inner',
              ['[f'] = '@function.outer',
              ['[k'] = '@assignment.lhs',
              ['[v'] = '@assignment.rhs',
            },
            goto_previous_end = {
              ['[A'] = '@parameter.inner',
              ['[B'] = '@block.inner',
              ['[F'] = '@function.outer',
              ['[K'] = '@assignment.lhs',
              ['[V'] = '@assignment.rhs',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>wa'] = '@parameter.inner',
              ['<leader>wf'] = '@function.outer',
            },
            swap_previous = {
              ['<leader>wA'] = '@parameter.inner',
              ['<leader>wF'] = '@function.outer',
            },
          },
        },
      }

      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

      -- Repeat movement with ; and ,
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end, 0)
  end
}
