--  Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
  vim.fn.system({'git', '-C', lazypath, 'checkout', '56ead98'})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/lazy.nvim',
    commit = '56ead98e05bb37a4ec28930a54d836d033cf00f2',
  },
  { import = 'plugins' },
}, {
  git = {
    timeout = 1000,
  },
})

require('config.options');
require('config.keymaps');
require('config.autocmds');
