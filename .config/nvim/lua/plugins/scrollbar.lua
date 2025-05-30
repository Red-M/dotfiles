return {
  "petertriho/nvim-scrollbar",
  lazy = false,
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    set_highlights = false,
    excluded_filetypes = vim.g.utils_ft["scrollbars"],
    handlers = {
      gitsigns = true,
    },
  },
}
