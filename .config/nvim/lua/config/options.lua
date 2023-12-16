vim.o.number = true
vim.o.relativenumber = false
vim.o.pumheight = 12
vim.o.shiftwidth = 4
vim.o.tabstop = 2
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.undofile = true
vim.o.hlsearch = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.swapfile = false
vim.o.laststatus = 3
vim.o.updatetime = 250
vim.o.termguicolors = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false
-- vim.o.whichwrap = 'lh'
vim.o.scrolloff = 8
vim.g.netrw_banner = 0
vim.o.foldenable = true
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.endoffile = true
vim.o.fixendofline = true
vim.o.clipboard = ""

vim.keymap.set("n", ";", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = ";"

vim.cmd([[
set whichwrap=<,>,[,]
set tw=150
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

]])

