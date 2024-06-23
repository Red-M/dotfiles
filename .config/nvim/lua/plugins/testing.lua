return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
      }
    end
  },
  -- {
    -- 'ggandor/leap.nvim',
    -- enabled = false,
  -- },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    opts = {
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

