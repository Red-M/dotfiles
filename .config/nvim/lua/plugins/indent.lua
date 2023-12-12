return {
  {
    'nmac427/guess-indent.nvim',
    lazy = false,
    config = function() require('guess-indent').setup({}) end,
  },
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    -- event = "LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
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
    version = false, -- wait till new 0.7.0 release to put it back on semver
    -- event = "LazyFile",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      require('mini.indentscope').gen_animation.none()
      vim.api.nvim_create_autocmd("FileType", {
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
    end,
  },
}
