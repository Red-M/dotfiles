return {
  {
    'johnfrankmorgan/whitespace.nvim',
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
      ft_ng = vim.g.utils_ft["default"],
    },
  },
}
