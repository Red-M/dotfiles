return {
  {
    "folke/which-key.nvim",
    -- enabled = false,
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
      local presets = require("which-key.plugins.presets")
      presets.operators['D'] = "Void-Delete"
      presets.operators['s'] = "Substitute"
      local wk = require("which-key")
      wk.setup({
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
        operators = {
          gc = "Comments",
          ["D"] = "Void-delete",
          s = "Substitute",
        },
        layout = {
          spacing = 0,
        },
      })
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["D"] = { name = "+Void-Delete" },
        ["s"] = { name = "+Substitute" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+help" },
        ["<leader>n"] = { name = "+noice" },
        ["<leader>o"] = { name = "+open" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader><tab>"] = { name = "+tabs" },
      })
    end,
    -- opts = {
    --   plugins = {
    --     marks = true, -- shows a list of your marks on ' and `
    --     registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    --     -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    --     -- No actual key bindings are created
    --     spelling = {
    --       enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    --       suggestions = 20, -- how many suggestions should be shown in the list?
    --     },
    --     presets = {
    --       operators = true, -- adds help for operators like d, y, ...
    --       motions = true, -- adds help for motions
    --       text_objects = true, -- help for text objects triggered after entering an operator
    --       windows = true, -- default bindings on <c-w>
    --       nav = true, -- misc bindings to work with windows
    --       z = true, -- bindings for folds, spelling and others prefixed with z
    --       g = true, -- bindings for prefixed with g
    --     },
    --   },
    --   operators = {
    --     gc = "Comments",
    --     D = "Void-delete",
    --     s = "Substitute",
    --   },
    --   layout = {
    --     spacing = 0,
    --   },
    -- },
    --opts = function(_, opts)
    --  if require("lazyvim.util").has("noice.nvim") then
    --    opts.defaults["<leader>sn"] = { name = "+noice" }
    --  end
    --end,
  },
}

