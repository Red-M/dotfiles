--vim.cmd([[autocmd BufWritePre <buffer> call Indent()]])

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("plugin_mini.indentscope",{clear = false}),
  pattern = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("plugin_bufferline",{clear = false}),
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("plugin_whitespace-nvim",{clear = false}),
  pattern = {"*"},
  callback = function(ev)
    local save_cursor = vim.fn.getpos(".")
    require('whitespace-nvim').trim()
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.api.nvim_create_autocmd({'BufRead','BufEnter'}, {
  group = vim.api.nvim_create_augroup("plugin_local-highlight_attach",{clear = false}),
  pattern = {'*.*'},
  callback = function(data)
    require('local-highlight').attach(data.buf)
  end
})

-- vim.api.nvim_create_autocmd("UiEnter", { -- Changed from BufReadPre
--   desc = "Open neo-tree on enter",
--   group = vim.api.nvim_create_augroup("always_show_neotree", { clear = true }),
--   once = true,
--   callback = function()
--   if not vim.g.neotree_opened then
--     require('neo-tree')
--     vim.cmd('Neotree show')
--     vim.g.neotree_opened = true
--   end
--   end,
-- })
vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
  group = vim.api.nvim_create_augroup("always_show_neotree",{clear = true}),
  -- pattern = {'*.*'},
  once = true,
  callback = function(data)
    if ((not (vim.g.neotree_opened)) and (not (vim.bo.filetype == "checkhealth"))) then
      require('neo-tree.command').execute({action='show'})
      -- vim.api.nvim_exec([[silent setlocal rnu]], false)
      vim.g.neotree_opened = true
    end
  end
})

vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter'}, {
  group = vim.api.nvim_create_augroup("always_set_neotree_options",{clear = true}),
  pattern = {'neo-tree*'},
  callback = function(data)
    if vim.bo.filetype == "neo-tree" then
      vim.wo.statuscolumn = [[%!v:lua.StatusCol()." "]]
      vim.wo.relativenumber = false
      vim.wo.number = true
      vim.wo.foldenable = false
      -- vim.api.nvim_exec([[silent setlocal rnu]], false)
    end
  end
})

vim.api.nvim_create_autocmd({'BufEnter','UIEnter','TabEnter','VimEnter','BufReadPost'}, {
  group = vim.api.nvim_create_augroup("plugin_Guess_Indent",{clear = true}),
  pattern = {'*'},
  -- once = true,
  -- command = "autocmd BufReadPost * :"
  callback = function(data)
    vim.api.nvim_exec([[silent lua require('guess-indent').set_from_buffer("auto_cmd")]], false)
    vim.api.nvim_exec([[silent GuessIndent]], false)
  end
})





