
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
" nnoremap <C-k> "Kdd
" inoremap <C-k> <C-o>"K<C-o>dd

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
" nnoremap <C-t> <cmd>Telescope<cr>
" inoremap <C-t> <cmd>Telescope<cr>


]])


local config_keymap = {

  -- Comments (Still not working)
  -- {"i", "<C-q>", [[<C-o>_<C-o>gcc]], {desc = "Toggle commenting the current line",}},
  -- {"n", "<C-q>", [[_gcc]], {desc = "Toggle commenting the current line",}},

  -- Search
  -- {"i", "<C-S-?>", [[<C-o>?]], {desc = "Search",}},

  -- Indent
  {"n", [[<Tab>]], [[_i<Tab><C-c>_]], {desc = "Indent current line",}},
  {"n", [[<S-Tab>]], [[_<<_]], {desc = "De-indent current line",}},
  {{"i","s"}, [[<Tab>]], [[a<BS><C-o>_<Tab><C-o>_]], {desc = "Indent current line",}},
  {{"i","s"}, [[<S-Tab>]], [[a<BS><C-o>_<C-o><<<C-o>_]], {desc = "De-indent current line",}},

  -- Delete line into the void
  -- {"n", [[<S-d><S-d>]], [["_dd:let @"=@0<cr>]], {desc = "Void-Delete the current line",}},
  -- {"n", [[<S-d>]], [["_d]], {desc = "Void-Delete",}},

  -- duplicate line
  {"n", [[<C-d>]], [["dY"dp:let @"=@0<cr>]], {desc = "Duplicate current line",}},
  {"i", [[<C-d>]], [[<C-o>"dY<C-o>"dp<C-o>:let @"=@0<cr>]], {desc = "Duplicate current line",}},

  -- Fake refresh of the current window
  -- {"n", [[<leader>r]], "<C-Left><C-Right>", {desc = [["Refresh" the window]],}},

  -- Line movement
  {{"i","n"}, [[<A-k>]], "<cmd>m .-2<cr>", {desc = "Move line up",}},
  {{"i","n"}, [[<A-Up>]], "<cmd>m .-2<cr>", {desc = "Move line up",}},
  {{"i","n"}, [[<A-j>]], "<cmd>m .+1<cr>", {desc = "Move line down",}},
  {{"i","n"}, [[<A-Down>]], "<cmd>m .+1<cr>", {desc = "Move line down",}},
  {"v", [[<A-k>]], "<cmd>m '<-2<cr>gv=gv", {desc = "Move line up",}},
  {"v", [[<A-Up>]], "<cmd>m '<-2<cr>gv=gv", {desc = "Move line up",}},
  {"v", [[<A-j>]], "<cmd>m '>+1<cr>gv=gv", {desc = "Move line down",}},
  {"v", [[<A-Down>]], "<cmd>m '>+1<cr>gv=gv", {desc = "Move line down",}},

  -- Base64
  {"v", [[<leader>Fb]], [[c<c-r>=system("base64 -w 0", @")<cr><esc>]], {desc = "Base64 encode"}},
  {"v", [[<leader>FB]], [[c<c-r>=system("base64 -d", @")<cr>]], {desc = "Base64 decode"}},

  -- Neotree
  -- {"n", [[\]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",}},
  -- {{"i","n"}, [[<C-\>]], "<cmd>Neotree reveal<cr>", {desc = "Neotree reveal",}},

  -- Guess Indent
  {"n", [[<leader>Gi]], "<cmd>GuessIndent<cr>", {desc = "Guess Indent",}},
  {"n", [[<leader>Ga]], "<cmd>IndentAuto<cr>", {desc = "Guess Indent and then reindent entire file",}},

  -- Buffer manager UI
  -- {"n", [[,]], [[<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<cr>]], {desc='Toggle buffer manager UI'}},

  -- Img-clip
  {"n", [[<leader>P]], [[<cmd>lua require("img-clip").pasteImage({ embed_image_as_base64 = true })<cr>]], {desc="Paste image in clipboard as base64"},},

  -- Telescope
  {{"i","n"}, [[<C-t>]], "<cmd>Telescope<cr>", {desc = "Telescope",}},

  {"n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory in Oil.nvim" }},

  -- better up/down
  {{ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }},
  {{ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }},
  {{ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }},
  {{ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }},

  -- Move to window using the <ctrl> hjkl keys
  {"n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true }},
  {"n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true }},
  {"n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true }},
  {"n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true }},

  -- Resize window using <ctrl> arrow keys
  {"n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" }},
  {"n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" }},
  {"n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" }},
  {"n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" }},

  -- Move Lines
  {"n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" }},
  {"n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" }},
  {"i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" }},
  {"i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" }},
  {"v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" }},
  {"v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" }},

  -- Clear search and stop snippet on escape
  {{ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
  end, { expr = true, desc = "Escape and Clear hlsearch" }},

  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  {"n", "<leader>ur", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>", { desc = "Redraw / Clear hlsearch / Diff Update" }},

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  {"n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" }},
  {"x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }},
  {"o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" }},
  {"n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" }},
  {"x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }},
  {"o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" }},

  -- save file
  {{ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" }},

  --keywordprg
  {"n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" }},

  -- better indenting
  {"v", "<", "<gv"},
  {"v", ">", ">gv"},

  -- commenting
  {"n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" }},
  {"n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" }},

  -- lazy
  {"n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" }},

  -- new file
  {"n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" }},

  -- quit
  {"n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" }},

  -- highlights under cursor
  {"n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" }},
  {"n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" }},

  -- buffers
  {"n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" }},
  {"n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" }},
  {"n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" }},
  {"n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" }},
  {"n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" }},
  {"n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" }},

  -- windows
  {"n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true }},
  {"n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true }},
  {"n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true }},

  -- tabs
  {"n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" }},
  {"n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" }},
  {"n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" }},
  {"n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" }},
  {"n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" }},
  {"n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" }},
  {"n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" }},

  -- because I'm not sure why you'd want a gj and I use S-j for buffer management
  {"n", "gj", "<S-j>", { desc = "Join" }},

}
for i,v in ipairs(config_keymap) do
  keymap.set(unpack(v))
end


