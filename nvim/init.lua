local opt = vim.o
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ';'

-- :h options
opt.number = true
opt.relativenumber = true
opt.mouse = ''
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.ignorecase = true
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.compatible = false
opt.expandtab = true
opt.scrolloff = 8
opt.termguicolors = true
opt.undofile = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.path = vim.o.path .. '**'
opt.colorcolumn = '80'
opt.exrc = true

-- colorscheme
opt.background = 'light'
vim.cmd.colorscheme('gruvbox')

-- diagnostic messages
vim.diagnostic.config {
  update_in_insert = true,
  virtual_text = {
    source = 'if_many',
    spacing = 4,
  },
}

-- unbreaks exrc functionality
-- vim.cmd('doautocmd DirChanged *')
