return {
  'booperlv/nvim-gomove',
  lazy = false,
  config = function()
    require("gomove").setup({})
  end,
}
