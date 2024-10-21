return {
  {
    'j-morano/buffer_manager.nvim',
  },
  {
    "akinsho/bufferline.nvim",
    -- enabled = false,
    --  lazy = false,
    event = { "BufReadPost", "BufNewFile", "User FileOpened", "VeryLazy" },
    --event = { "VeryLazy", },
    opts = {
      options = {
        themable = true,
        theme = "auto",
        always_show_bufferline = true,
        -- separator_style = "thin",
        numbers = "both",
        separator_style = "slant",
        --separator_style = "padded_slant",
        sort_by = 'none',
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        move_wraps_at_ends = true,
        buffer_close_icon = vim.g.my_icons["close"],
        close_icon = vim.g.my_icons["close"],
        modified_icon = vim.g.my_icons["modified"],
        -- stylua: ignore
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
      { "<S-k>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
      { "<S-j>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
      { "<A-l>", "gt", desc = "Next tab" },
      { "<A-h>", "gT", desc = "Previous tab" },
    },
  },
  -- {
  --   'romgrk/barbar.nvim',
  --   enabled = false,
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function() vim.g.barbar_auto_setup = false end,
  --   opts = {
  --     animation = false,
  --     maximum_padding = 1,
  --     minimum_padding = 1,
  --     icons = {
  --       preset = 'slanted',
  --       -- separator = {left = vim.g.my_icons["slant_left"], right = vim.g.my_icons["slant_right"]},
  --       buffer_index = true,
  --       buffer_number = true,
  --       button = vim.g.my_icons["close"],
  --       modified = {button = vim.g.my_icons["modified"]},
  --       inactive = {button = vim.g.my_icons["close"]},
  --     },
  --   },
  --   config = function(_, pack_opts)
  --     local map = vim.api.nvim_set_keymap
  --     local opts = { noremap = true, silent = true }
  --
  --     -- Move to previous/next
  --     map('n', '<S-h>', '<Cmd>BufferPrevious<CR>', opts)
  --     map('n', '<S-l>', '<Cmd>BufferNext<CR>', opts)
  --     -- Re-order to previous/next
  --     map('n', '<S-j>', '<Cmd>BufferMovePrevious<CR>', opts)
  --     map('n', '<S-k>', '<Cmd>BufferMoveNext<CR>', opts)
  --     -- Goto buffer in position...
  --     map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
  --     map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
  --     map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
  --     map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
  --     map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
  --     map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
  --     map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
  --     map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
  --     map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
  --     map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
  --     -- Pin/unpin buffer
  --     map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
  --     -- Goto pinned/unpinned buffer
  --     --                 :BufferGotoPinned
  --     --                 :BufferGotoUnpinned
  --     -- Close buffer
  --     map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
  --     -- Wipeout buffer
  --     --                 :BufferWipeout
  --     -- Close commands
  --     --                 :BufferCloseAllButCurrent
  --     --                 :BufferCloseAllButPinned
  --     --                 :BufferCloseAllButCurrentOrPinned
  --     --                 :BufferCloseBuffersLeft
  --     --                 :BufferCloseBuffersRight
  --     -- Magic buffer-picking mode
  --     map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
  --     -- Sort automatically by...
  --     map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
  --     map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>', opts)
  --     map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
  --     map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
  --     map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
  --
  --     -- Other:
  --     -- :BarbarEnable - enables barbar (enabled by default)
  --     -- :BarbarDisable - very bad command, should never be used
  --     require('barbar').setup(pack_opts)
  --     vim.cmd('BufferOrderByBufferNumber')
  --   end,
  -- },
}

