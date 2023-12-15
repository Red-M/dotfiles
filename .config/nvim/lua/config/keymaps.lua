
vim.keymap.set({"i","n","v"}, [[<C-S-:>]], "<cmd>", { remap = false }) -- Allow command from any mode

vim.cmd([[
" Allow command from anywhere
"nnoremap <C-S-:> :
"inoremap <C-S-:> <C-O>:
"vnoremap <C-S-:> :

" gqap -- reformat paragraph

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
nnoremap <C-d> "_Yp
inoremap <C-d> <C-O>"_<C-O>Y<C-O>p

" save file
"nnoremap <C-s> w
"nnoremap <C-s> w
"inoremap <C-s> w

" Telescope
nnoremap <C-T> <cmd>Telescope<CR>
inoremap <C-T> <cmd>Telescope<CR>


]])

vim.keymap.set("n", "<C-d>", [["dYp]]) -- duplicate line
vim.keymap.set("i", "<C-d>", [[<C-O>"d<C-O>Y<C-O>p]]) -- duplicate line

vim.keymap.set({"i","n"}, "<A-j>", "<cmd>m .+1<CR>") -- move line up(n)
vim.keymap.set({"i","n"}, "<A-k>", "<cmd>m .-2<CR>") -- move line down(n)
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv") -- move line down(v)

vim.keymap.set("n", [[\]], "<cmd>Neotree reveal<cr>")
vim.keymap.set({"i","n"}, [[<C-\>]], "<cmd>Neotree reveal<cr>")
