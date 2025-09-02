return {
  {
    "HakonHarnes/img-clip.nvim",
    enabled = not vim.g.nvimpager,
    event = "BufEnter",
    opts = {
      max_base64_size = 6000, -- max size of base64 string in KB
      embed_image_as_base64 = true,
    },
    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
}
