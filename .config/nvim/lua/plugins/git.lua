return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.nvimpager,
    --event = { "BufReadPost", "BufNewFile", "LazyFile" },
    -- event = {"BufReadPost", "BufNewFile", "BufWritePre"},
    lazy = false,
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┃" },
        untracked = { text = "┃" },
      },
      on_attach = function(buffer)
        local gs = require('gitsigns')

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      end,
    },
  },
  {'akinsho/git-conflict.nvim', version = "*", config = true},
}
