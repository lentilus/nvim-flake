local cmd = vim.cmd
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

-- indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- search down into subfolders
opt.path = vim.o.path .. '**'

-- 80 line hint
opt.colorcolumn = '80'

-- diagnostic messages
vim.diagnostic.config {
  update_in_insert = true,
  virtual_text = {
    source = 'if_many',
    spacing = 4,
  },
}

-- make sure color scheme is set before other plugins load
require('gruvbox').setup { contrast = 'hard', dim_inactive = false, transparent_mode = false }
cmd.colorscheme('gruvbox')
