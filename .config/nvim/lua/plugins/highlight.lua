
-- vim.api.nvim_create_autocmd({'BufRead','BufEnter','UIEnter','TabEnter'}, {
--   group = vim.api.nvim_create_augroup("plugin_local-highlight_attach",{clear = false}),
--   pattern = {'*.*'},
--   callback = function(data)
--     require('local-highlight').attach(data.buf)
--   end
-- })

return {
  {
    'tzachar/local-highlight.nvim',
    lazy = false,
    config = function()
      require('local-highlight').setup({
        file_types = nil,
        disable_file_types = nil,
        animate = { enabled = false, },
        insert_mode = true,
        highlight_single_match = true,
      })
    end,
  },
}
