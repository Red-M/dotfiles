
local keymap = vim.keymap

keymap.set({"n","v"}, [[<A-:>]], ":", { remap = false }) -- Allow command from any mode
keymap.set({"i"}, [[<A-:>]], "<C-o>:", { remap = false }) -- Allow command from any mode

vim.cmd([[
" Allow command from anywhere
"nnoremap <C-S-:> :
"inoremap <C-S-:> <C-o>:
"vnoremap <C-S-:> :

" gqap -- reformat paragraph

" Search from insert
" inoremap <C-?> <C-o>?
" inoremap <C-S-?> <C-o>?

" indent
" for command mode
" nnoremap <Tab> _i<tab><C-c>_
" nnoremap <S-Tab> _<<_
" for insert mode
" inoremap <S-Tab> <C-o>_<C-o><<<C-o>_
" inoremap <Tab> <C-o>_<tab><C-o>_

" del line after cursor and the entire line
"nnoremap <C-k> c$
"inoremap <C-k> <C-o>d$
"nnoremap <C-S-k> "Kdd
"inoremap <C-S-k> <C-o>"Kdd
nnoremap <C-k> "Kdd
inoremap <C-k> <C-o>"K<C-o>dd

" comment toggle
" nnoremap <C-q> _gcc
" inoremap <C-a> <C-o>_<C-o>gcc

" duplicate line
"nnoremap <C-d> "_yyp
"inoremap <C-d> <C-o>"_<C-o>Y<C-o>p

" save file
"nnoremap <C-s> w
"nnoremap <C-s> w
"inoremap <C-s> w

" Telescope
" nnoremap <C-t> <cmd>Telescope<CR>
" inoremap <C-t> <cmd>Telescope<CR>


]])


local config_keymap = {

  -- Comments (Still not working)
  -- {"i", "<C-q>", [[<C-o>_<C-o>gcc]], {desc = "Toggle commenting the current line",}},
  -- {"n", "<C-q>", [[_gcc]], {desc = "Toggle commenting the current line",}},

  -- Search
  -- {"i", "<C-S-?>", [[<C-o>?]], {desc = "Search",}},

  -- Indent
  {"n", "<Tab>", [[_i<tab><C-c>_]], {desc = "Indent current line",}},
  {"n", "<S-Tab>", [[_<<_]], {desc = "De-indent current line",}},
  {"i", "<Tab>", [[<C-o>_<tab><C-o>_]], {desc = "Indent current line",}},
  {"i", "<S-Tab>", [[<C-o>_<C-o><<<C-o>_]], {desc = "De-indent current line",}},

  -- Delete line into the void
  {"n", "DD", [["_dd]], {desc = "Void-Delete the current line",}},
  {"n", "Dd", [["_dd]], {desc = "Void-Delete the current line",}},
  {"n", "D", [["_d]], {desc = "+Void-Delete",}},

  -- duplicate line
  {"n", "<C-d>", [["dY"dp]], {desc = "Duplicate current line",}},
  {"i", "<C-d>", [[<C-o>"dY<C-o>"dp]], {desc = "Duplicate current line",}},

  -- Fake refresh of the current window
  {"n", [[<leader>r]], "<C-Left><C-Right>", {desc = [["Refresh" the window]],}},

  -- Line movement
  {{"i","n"}, "<A-k>", "<cmd>m .-2<CR>", {desc = "Move line up",}},
  {{"i","n"}, "<A-Up>", "<cmd>m .-2<CR>", {desc = "Move line up",}},
  {{"i","n"}, "<A-j>", "<cmd>m .+1<CR>", {desc = "Move line down",}},
  {{"i","n"}, "<A-Down>", "<cmd>m .+1<CR>", {desc = "Move line down",}},
  {"v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", {desc = "Move line up",}},
  {"v", "<A-Up>", "<cmd>m '<-2<CR>gv=gv", {desc = "Move line up",}},
  {"v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", {desc = "Move line down",}},
  {"v", "<A-Down>", "<cmd>m '>+1<CR>gv=gv", {desc = "Move line down",}},

  -- Base64
  {"v", [[<leader>Fb]], [[c<c-r>=system("base64 -w 0", @")<cr><esc>]], {desc = "Base64 encode"}},
  {"v", [[<leader>FB]], [[c<c-r>=system("base64 -d", @")<cr>]], {desc = "Base64 decode"}},

  -- Neotree
  {"n", [[\]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",}},
  {{"i","n"}, [[<C-\>]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",}},

  -- Guess Indent
  {"n", [[<leader>Gi]], "<cmd>GuessIndent<cr>", {desc = "Guess Indent",}},
  {"n", [[<leader>Ga]], "<cmd>IndentAuto<cr>", {desc = "Guess Indent and then reindent entire file",}},

  -- Buffer manager UI
  {"n", ',', [[<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<CR>]], {desc='Toggle buffer manager UI'}},

  -- Img-clip
  {"n", [[<leader>P]], [[<cmd>lua require("img-clip").pasteImage({ embed_image_as_base64 = true })<CR>]], {desc="Paste image in clipboard as base64"},},

  -- Telescope
  {{"i","n"}, "<C-t>", "<cmd>Telescope<CR>", {desc = "Telescope",}},



}

for i,v in ipairs(config_keymap) do
  keymap.set(unpack(v))
end

