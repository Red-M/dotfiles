return {
  {
    "gbprod/substitute.nvim",
    branch = "main",
    lazy = false,
    config = function(_, opts)
      local subs = require('substitute')
      subs.setup(opts)
      vim.keymap.set('n', 'S', subs.eol, { noremap = true })
      vim.keymap.set('n', 's', subs.operator, { noremap = true })
      vim.keymap.set('n', 'ss', subs.line, { noremap = true })
      vim.keymap.set('x', 's', subs.visual, { noremap = true })
    end,
    opts = {
      preserve_cursor_position = true,
      on_substitute = function() require("yanky.integration").substitute() end,
    },
    keys = {
      { mode = "n", "s", nil, desc = "Substitue", noremap = true, },
      { mode = "n", "ss", nil, desc = "Substitue current line", noremap = true },
      { mode = "n", "S", nil, desc = "Substitue to eol", noremap = true },
      { mode = "v", "s", nil, desc = "Substitue", noremap = true },
    },
  },
}
