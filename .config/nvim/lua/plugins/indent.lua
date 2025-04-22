
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

return {
  {
    'nmac427/guess-indent.nvim',
    lazy = false,
    opts = {
      auto_cmd = true,
      on_tab_options = { -- A table of vim options when tabs are detected
        ["expandtab"] = false,
      },
      on_space_options = { -- A table of vim options when spaces are detected
        ["expandtab"] = true,
        ["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
        ["softtabstop"] = "detected",
        ["shiftwidth"] = "detected",
      },
    },
    config = function(_, opts)
      require('guess-indent').setup(opts)
    end,
  },
  -- indent guides for Neovim
  --{ import = "lazyvim.plugins.extras.ui.indent-blankline" },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    -- event = "LazyFile",
    --event = "User FileOpened",
    opts = {
      indent = {
        --char = "│",
        char = "┊",
        --tab_char = "│",
        tab_char = "┊",
      },
      scope = { enabled = false, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "snacks_dashboard",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "toggleterm",
          "trouble",
        },
      },
    },
    main = "ibl",
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    enabled = true,
    lazy = false,
    --version = "*", -- wait till new 0.7.0 release to put it back on semver
    --event = "LazyFile",
    -- opts = {
    --   symbol = "│",
    --   options = { try_as_border = true },
    -- },
    opts = function()
      local mini_indentscope = require('mini.indentscope')
      return {
        --symbol = "│",
        symbol = "┊",
        draw = {
          animation = mini_indentscope.gen_animation.none()
        },
        options = { try_as_border = false },
      }
    end,
  },
}
