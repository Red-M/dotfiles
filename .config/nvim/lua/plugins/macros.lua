return {
  {
    "ecthelionvi/NeoComposer.nvim",
    enabled = not vim.g.nvimpager,
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      notify = true,
      delay_timer = 150,
      queue_most_recent = false,
      window = {
        width = 60,
        height = 10,
        border = "rounded",
        winhl = {
          Normal = "ComposerNormal",
        },
      },
      colors = {
        bg = "#16161e",
        fg = "#ff9e64",
        red = "#ec5f67",
        blue = "#5fb3b3",
        green = "#99c794",
      },
      keymaps = {
        play_macro = "<C-Q>",
        yank_macro = "yq",
        stop_macro = "cq",
        toggle_record = "<C-q>",
        cycle_next = "<C-n>",
        cycle_prev = "<C-p>",
        toggle_macro_menu = "<M-q>",
        -- play_macro = "Q",
        -- yank_macro = "yq",
        -- stop_macro = "cq",
        -- toggle_record = "q",
        -- cycle_next = "<c-n>",
        -- cycle_prev = "<c-p>",
        -- toggle_macro_menu = "<m-q>",
      },
    },
    keys = {
      {"<C-Q>", nil, desc = "NeoComposer play macro"},
      {"yq", nil, desc = "NeoComposer yank macro"},
      {"cq", nil, desc = "NeoComposer stop macro"},
      {"<C-q>", nil, desc = "NeoComposer toggle macro record"},
      {"<C-n>", nil, desc = "NeoComposer cycle next step in macro"},
      {"<C-p>", nil, desc = "NeoComposer cycle previous step in macro"},
      {"<M-q>", nil, desc = "NeoComposer toggle macro menu"},
    }
  },
}

