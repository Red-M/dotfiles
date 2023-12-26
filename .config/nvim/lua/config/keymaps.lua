
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
nnoremap <Tab> _i<tab><C-c>_
nnoremap <S-Tab> _<<_
" for insert mode
inoremap <S-Tab> <C-O>_<C-O><<<C-O>_
inoremap <Tab> <C-O>_<tab><C-O>_

" del line after cursor and the entire line
"nnoremap <C-k> c$
"inoremap <C-k> <C-O>d$
"nnoremap <C-S-k> "Kdd
"inoremap <C-S-k> <C-O>"Kdd
nnoremap <C-k> "Kdd
inoremap <C-k> <C-O>"K<C-O>dd

" comment toggle
nnoremap <C-q> gcc
inoremap <C-q> <C-O>gcc

" duplicate line
"nnoremap <C-d> "_yyp
"inoremap <C-d> <C-O>"_<C-O>Y<C-O>p

" save file
"nnoremap <C-s> w
"nnoremap <C-s> w
"inoremap <C-s> w

" Telescope
nnoremap <C-T> <cmd>Telescope<CR>
inoremap <C-T> <cmd>Telescope<CR>


]])

vim.keymap.set("n", "<C-d>", [["dYp]], {desc = "Duplicate line",}) -- duplicate line
vim.keymap.set("i", "<C-d>", [[<C-O>"d<C-O>yy<C-O>p]], {desc = "Duplicate line",}) -- duplicate line

vim.keymap.set({"i","n"}, "<A-j>", "<cmd>m .+1<CR>", {desc = "Move line down",}) -- move line up(n)
vim.keymap.set({"i","n"}, "<A-k>", "<cmd>m .-2<CR>", {desc = "Move line up",}) -- move line down(n)
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", {desc = "Move line down",}) -- move line up(v)
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", {desc = "Move line up",}) -- move line down(v)

vim.keymap.set("n", [[\]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",})
vim.keymap.set({"i","n"}, [[<C-\>]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",})

vim.keymap.set("n", [[<leader>Gi]], "<cmd>GuessIndent<cr>", {desc = "Guess Indent",})
vim.keymap.set("n", [[<leader>Ga]], "<cmd>IndentAuto<cr>", {desc = "Guess Indent and then reindent entire file",})

vim.keymap.set("n", ',', [[<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<CR>]], {desc='Toggle buffer manager UI'})

