return {
  {
    "akinsho/bufferline.nvim",
    config = function()
      require('bufferline').setup({
        options = {
          themable = true,
          always_show_bufferline = true,
          separator_style = "thin",
          show_duplicate_prefix = true,
          move_wraps_at_ends = false,
        }
      })
    end,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<C-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
      { "<C-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
      { "<C-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
      { "<C-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
      { "<C-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
      { "<C-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
      { "<C-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7" },
      { "<C-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8" },
      { "<C-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9" },
      { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<A-S-l>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
      { "<A-S-h>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
    },
  },{
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'location'},
        lualine_c = {'filename'},
        lualine_z = {'progress'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'diff', 'diagnostics'}
      },
    },
  },
}
