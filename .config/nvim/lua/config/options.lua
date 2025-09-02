vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.pumheight = 12
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.opt.updatetime = 250
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.whichwrap = "<,>,[,]"
-- vim.opt.backspace = "eol,start"

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 12
vim.g.netrw_banner = 0

vim.opt.foldenable = true
vim.opt.foldcolumn = "1" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99

vim.opt.endoffile = true
vim.opt.fixendofline = true
vim.opt.fixeol = true
vim.opt.eol = true

vim.opt.clipboard = nil
vim.opt.conceallevel = 0

-- LazyVim
vim.g.linebreak = false
vim.g.trouble_lualine = false
vim.g.snacks_animate = false
vim.g.lazyvim_check_order = false
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.termguicolors = true -- True color support
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.smoothscroll = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.autowrite = true -- Enable auto write
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.ruler = false -- Disable the default ruler
vim.opt.spelllang = { "en" }
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.foldtext = ""
-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.keymap.set("n", ";", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = ";"

vim.g.my_icons = {
  ["close"] = '☒',
  ["modified"] = '‼',
  ["slant_left"] = '',
  ["slant_right"] = '',
}


local utils_ft = {
  ["scrollbars"] = {
    "alpha",
    "dashboard",
    "DressingInput",
    "mason",
    "noice",
    "prompt",
    "TelescopePrompt",
  },
  ["misc"] = {
    "qf",
    "alpha",
    "buffer_manager",
    "dashboard",
    "DressingInput",
    'help',
    "lazy",
    "mason",
    'neo-tree',
    "noice",
    'NvimTree',
    "prompt",
    'TelescopePrompt',
    'Trouble',
  }
}
local utils_ft_default = {}
for key, value in pairs(utils_ft) do
  vim.list_extend(utils_ft_default,value)
end
vim.g.utils_ft = vim.tbl_extend('force',utils_ft,{["default"] = utils_ft_default})

vim.cmd([[
" set tw=150
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

function! Preserve(command)
" Save the last search.
let search = @/

" Save the current cursor position.
let cursor_position = getpos('.')

" Save the current window position.
normal! H
let window_position = getpos('.')
call setpos('.', cursor_position)

" Execute the command.
execute a:command

" Restore the last search.
let @/ = search

" Restore the previous window position.
call setpos('.', window_position)
normal! zt

" Restore the previous cursor position.
call setpos('.', cursor_position)
endfunction

" Re-indent the whole buffer.
function! Indent()
GuessIndent
call Preserve('normal gg=G')
endfunction

command! IndentAuto call Indent()

]])

if vim.g.nvimpager == true then
  nvimpager.maps = false
end

