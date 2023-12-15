
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
