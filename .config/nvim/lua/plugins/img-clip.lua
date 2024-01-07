return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    opts = {
      max_base64_size = 20, -- max size of base64 string in KB
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
}
