
vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("plugin_bufferline",{clear = false}),
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})

return {
  {
    'j-morano/buffer_manager.nvim',
    opts = {
      width = 0.75,
      height = 0.75,
      highlight = 'Normal:BufferManagerBorder',
      win_extra_options = {
        winhighlight = 'Normal:BufferManagerNormal',
      },
    },
    keys = {
      { [[,]], [[<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<cr>]], desc='Toggle buffer manager UI' }
    },
  },
  {
    "akinsho/bufferline.nvim",
    -- enabled = false,
    lazy = false,
    -- event = { "BufReadPost", "BufNewFile", "User FileOpened", "VeryLazy" },
    --event = { "VeryLazy", },
    opts = {
      options = {
        themable = true,
        theme = "auto",
        always_show_bufferline = true,
        numbers = "both",
        separator_style = "slant",
        sort_by = 'none',
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        move_wraps_at_ends = false,
        buffer_close_icon = vim.g.my_icons["close"],
        close_icon = vim.g.my_icons["close"],
        modified_icon = vim.g.my_icons["modified"],
        show_buffer_icons = true,
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        --diagnostics = "nvim_lsp",
        offsets = {
          --   {
          --   filetype = "neo-tree",
          --   text = "Neo-tree",
          --   highlight = "Directory",
          --   text_align = "left",
          --   },
        },
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },

      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-k>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
      { "<S-j>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "<A-l>", "gt", desc = "Next tab" },
      { "<A-h>", "gT", desc = "Previous tab" },
    },
  },
}

