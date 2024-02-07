return {
  {
    "gbprod/substitute.nvim",
    -- config = function(_, opts)
    --   require("which-key").register({
    --     ["s"] = { name = "substitue" },
    --   })
    --   _.setup(opts)
    -- end,
    opts = {
      preserve_cursor_position = false,
    },
    keys = {
      { mode = "n", "s", function() require('substitute').operator() end, desc = "Substitue", noremap = true, },
      { mode = "n", "ss", function() require('substitute').line() end, desc = "Substitue current line", noremap = true },
      { mode = "n", "S", function() require('substitute').eol() end, desc = "Substitue to eol", noremap = true },
      { mode = "x", "s", function() require('substitute').visual() end, desc = "Substitue", noremap = true },
    },
  },
}

