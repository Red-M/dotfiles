return {
  {
    "folke/which-key.nvim",
    enabled = not vim.g.nvimpager,
  -- },
  -- {
    -- "njhoffman/which-key.nvim",
    -- branch = "master",
    priority = 500,
    -- event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.setup({
        replace = {
          key = {
            function(key)
              return key
            end,
          },
        },
        icons = {
          -- rules = false,
        },
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
          },
        },
        layout = {
          spacing = 0,
        },
      })

      wk.add({
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>G", group = "Guess-Indent" },
        { "<leader>h", group = "help" },
        { "<leader>n", group = "noice" },
        { "<leader>o", group = "open" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "=", group = "Indent" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "s", group = "Substitute" },
        { "f", group = "folds" },
        { "z", group = "util" },
        { "<leader>", group = "leader" },
      })

    end,
  },
}

