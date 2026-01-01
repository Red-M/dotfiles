
vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
  group = vim.api.nvim_create_augroup("bad_cmdheight_go_away",{clear = true}),
  pattern = {'*'},
  callback = function(data)
    vim.cmd([[ silent set cmdheight=0 ]])
  end
})

vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
  group = vim.api.nvim_create_augroup("make_spellcheck_global",{clear = true}),
  pattern = {'*'},
  callback = function(data)
    vim.opt.spell = vim.g.spell
  end
})

