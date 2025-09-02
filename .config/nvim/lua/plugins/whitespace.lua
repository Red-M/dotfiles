
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("plugin_whitespace-nvim",{clear = false}),
  pattern = {"*"},
  callback = function(data)
    local save_cursor = vim.fn.getpos(".")
    require('whitespace-nvim').trim()
    vim.fn.setpos(".", save_cursor)
  end,
})

return {
  {
    'johnfrankmorgan/whitespace.nvim',
    enabled = not vim.g.nvimpager,
    config = function ()
      require('whitespace-nvim').setup({
        -- configuration options and their defaults

        -- `highlight` configures which highlight is used to display
        -- trailing whitespace
        highlight = 'DiffDelete',

        -- `ignored_filetypes` configures which filetypes to ignore when
        -- displaying trailing whitespace
        ignored_filetypes = vim.g.utils_ft["default"],

        -- `ignore_terminal` configures whether to ignore terminal buffers
        ignore_terminal = true,
      })

    end,
    -- remove trailing whitespace with a keybinding
    keys = {{'<Leader>t', function() require('whitespace-nvim').trim() end, desc = 'Trim whitespace in current file',},},
  },{
    "cappyzawa/trim.nvim",
    opts = {
      ft_blocklist = vim.g.utils_ft["default"],
      patterns = {},
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = false,
      trim_first_line = false,
    },
  },{
    "LumaKernel/nvim-visual-eof.lua",
    lazy = false,
    config = function(_, opts)
      require('visual-eof').setup(opts)
    end,
    opts = {
      -- ft_ng = vim.g.utils_ft["default"],
      buf_filter = function(bufnr)
        return(not vim.tbl_contains(vim.g.utils_ft["default"],vim.api.nvim_buf_get_option(bufnr, 'filetype')))
      end,
    },
  },
}
