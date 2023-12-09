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

vim.cmd([[
set whichwrap=<,>,[,]

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
" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>
inoremap <Tab> <C-i>

" del line
nnoremap <C-k> dd
inoremap <C-k> <C-O>dd

" comment toggle
nnoremap <c-q> gcc
inoremap <c-q> <c-O>gcc

" save file
"nnoremap <C-s> w
"inoremap <C-s> w



]])
