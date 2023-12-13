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



vim.keymap.set("n", ";", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = ";"

vim.keymap.set({"i","n","v"}, [[<C-S-:>]], "<C-O><cmd>", { remap = false }) -- Allow command from any mode
vim.keymap.set("i", "<C-;>", "<leader>", { remap = false })

vim.cmd([[
set whichwrap=<,>,[,]
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

]])

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = {"*"},
  callback = function(ev)
    local save_cursor = vim.fn.getpos(".")
    require('whitespace-nvim').trim()
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.cmd([[
" Allow command from anywhere
"nnoremap <C-S-:> :
"inoremap <C-S-:> <C-O>:
"vnoremap <C-S-:> :

" Search from insert
inoremap <C-S-?> <C-O>?

" indent
" for command mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>
inoremap <Tab> <C-i>

" del line after cursor and the entire line
nnoremap <C-k> c$
inoremap <C-k> <C-O>d$
nnoremap <C-S-k> "Kdd
inoremap <C-S-k> <C-O>"Kdd

" comment toggle
nnoremap <C-q> gcc
inoremap <C-q> <C-O>gcc

" duplicate line
nnoremap <C-d> Yp
inoremap <C-d> <C-O>Y<C-O>p

" save file
"nnoremap <C-s> w
"inoremap <C-s> w

" Telescope
nnoremap <C-T> <cmd>Telescope<CR>
inoremap <C-T> <cmd>Telescope<CR>


]])

vim.keymap.set({"i","n"}, "<A-j>", "<cmd>m .+1<CR>") -- move line up(n)
vim.keymap.set({"i","n"}, "<A-k>", "<cmd>m .-2<CR>") -- move line down(n)
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv") -- move line down(v)

