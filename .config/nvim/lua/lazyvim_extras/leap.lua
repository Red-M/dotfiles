return {
  { import = "lazyvim.plugins.extras.editor.leap" },
  {
    "ggandor/leap.nvim",
    enabled = true,
    lazy = false,
    keys = {
      { "x", mode = { "n" }, desc = "Leap to" },
      { "gs", mode = { "n" }, desc = "Leap from Windows" },
      { "x", mode = { "x", "o" }, desc = "Leap Forward to" },
      { "X", mode = { "x", "o" }, desc = "Leap Backward to" },
    },
    opts = {
      create_default_mappings = false,
    },
    config = function(_, opts)
      local leap = require("leap")
      leap.setup(opts)
      -- for k, v in pairs(opts) do
      --   leap.opts[k] = v
      -- end
      -- leap.add_default_mappings(true)
      -- vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.set('n',        'x', '<Plug>(leap)')
      vim.keymap.set('n',        'gs', '<Plug>(leap-from-window)')
      vim.keymap.set({'x', 'o'}, 'x', '<Plug>(leap-forward)')
      vim.keymap.set({'x', 'o'}, 'X', '<Plug>(leap-backward)')
    end,
  },
}

