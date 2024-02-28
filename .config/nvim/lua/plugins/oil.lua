return {
  {
    'stevearc/oil.nvim',
    -- enabled = false,
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = false,
      experimental_watch_for_changes = false,
      columns = {
        -- "icon",
        -- "permissions",
        -- "size",
      },
      view_options = {
        show_hidden = false,
      },
    },
  },
}
