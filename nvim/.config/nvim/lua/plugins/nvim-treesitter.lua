local parsers = {
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
  'asm',
}

local function start_treesitter()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  local language = vim.treesitter.language.get_lang(filetype) or filetype

  if not language or language == '' then
    return
  end

  if vim.treesitter.language.add(language) then
    vim.treesitter.start(bufnr, language)
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local function map_select(keys, query)
  vim.keymap.set({ 'x', 'o' }, keys, function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
  end)
end

local function map_move(keys, query, direction)
  vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
    require('nvim-treesitter-textobjects.move')[direction](query, 'textobjects')
  end)
end

return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = function()
    require('nvim-treesitter').install(parsers):wait(300000)
  end,
  config = function()
    require('nvim-treesitter').setup()

    if #vim.api.nvim_list_uis() > 0 then
      require('nvim-treesitter').install(parsers)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterFeatures', { clear = true }),
      pattern = parsers,
      callback = start_treesitter,
    })

    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    map_select('aa', '@parameter.outer')
    map_select('ia', '@parameter.inner')
    map_select('af', '@function.outer')
    map_select('if', '@function.inner')
    map_select('ac', '@class.outer')
    map_select('ic', '@class.inner')
    map_select('ar', '@parameter.outer')
    map_select('ab', '@block.outer')
    map_select('ib', '@block.inner')
    map_select('ak', '@assignment.lhs')
    map_select('ik', '@assignment.lhs')
    map_select('av', '@assignment.rhs')
    map_select('iv', '@assignment.rhs')

    map_move(']a', '@parameter.inner', 'goto_next_start')
    map_move(']b', '@block.inner', 'goto_next_start')
    map_move(']f', '@function.outer', 'goto_next_start')
    map_move(']k', '@assignment.lhs', 'goto_next_start')
    map_move(']v', '@assignment.rhs', 'goto_next_start')

    map_move(']A', '@parameter.inner', 'goto_next_end')
    map_move(']B', '@block.inner', 'goto_next_end')
    map_move(']F', '@function.outer', 'goto_next_end')
    map_move(']K', '@assignment.lhs', 'goto_next_end')
    map_move(']V', '@assignment.rhs', 'goto_next_end')

    map_move('[a', '@parameter.inner', 'goto_previous_start')
    map_move('[b', '@block.inner', 'goto_previous_start')
    map_move('[f', '@function.outer', 'goto_previous_start')
    map_move('[k', '@assignment.lhs', 'goto_previous_start')
    map_move('[v', '@assignment.rhs', 'goto_previous_start')

    map_move('[A', '@parameter.inner', 'goto_previous_end')
    map_move('[B', '@block.inner', 'goto_previous_end')
    map_move('[F', '@function.outer', 'goto_previous_end')
    map_move('[K', '@assignment.lhs', 'goto_previous_end')
    map_move('[V', '@assignment.rhs', 'goto_previous_end')

    vim.keymap.set('n', '<leader>wa', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end)
    vim.keymap.set('n', '<leader>wf', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@function.outer')
    end)
    vim.keymap.set('n', '<leader>wA', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end)
    vim.keymap.set('n', '<leader>wF', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@function.outer')
    end)

    local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
