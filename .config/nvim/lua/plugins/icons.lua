return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      default = true,
      strict = true,
      override_by_filename = {
        [".keep"] = {icon = "", color = "#f1502f",},
      },
    },
  },
--   {
--     'glepnir/nerdicons.nvim',
--     cmd = 'NerdIcons',
--   },
-- This breaks terraform highlights????
--
}

