return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  {
    'ggandor/leap.nvim',
    enabled = false,
  },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    'anuvyklack/hydra.nvim',
    enabled = false,
  },
  {
    'ThePrimeagen/vim-be-good',
  },
}

