return {
  {
    'tzachar/local-highlight.nvim',
    lazy = false,
    config = function()
      require('local-highlight').setup({
        file_types = nil,
        disable_file_types = nil,
        animate = { enabled = false, },
        insert_mode = true,
        highlight_single_match = true,
      })
    end,
  },
}
