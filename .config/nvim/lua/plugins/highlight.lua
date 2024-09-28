return {
  {
    'tzachar/local-highlight.nvim',
    lazy = false,
    config = function()
      require('local-highlight').setup({
        insert_mode = true,
        highlight_single_match = true,
      })
    end,
  },
}
