--local nv_statusline = require("nvim-treesitter.statusline")
-- local treesitter_status_line = function()
--   return nv_statusline.statusline({
--     -- type_patterns = {".*",},
--   })
-- end
local Util = require("lazyvim.util")

return {
  {
    "akinsho/bufferline.nvim",
--    lazy = false,
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
        sort_by = 'id',
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        move_wraps_at_ends = true,
        buffer_close_icon = "☒",
        close_icon = "☒",
        modified_icon = "‼",
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        --diagnostics = "nvim_lsp",
        --always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
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
      { "<A-S-l>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
      { "<A-S-h>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
    },
  },{
    "nvim-lualine/lualine.nvim",
    --lazy = false,
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter",
    -- },
    -- event = { "BufReadPost", "BufNewFile" },
    --event = { "VeryLazy", },
    -- init = function()
    --   vim.g.lualine_laststatus = vim.o.laststatus
    --   if vim.fn.argc(-1) > 0 then
    --     -- set an empty statusline till lualine loads
    --     vim.o.statusline = " "
    --   else
    --     -- hide the statusline on the starter page
    --     vim.o.laststatus = 0
    --   end
    -- end,
    opts = {
      options = {
        globalstatus = false,
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'location'},
        --lualine_c = {Util.lualine.root_dir(),'filename',Util.lualine.pretty_path({relative="root",})},
        lualine_c = {Util.lualine.pretty_path({relative="root",})},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = { 'filetype', 'encoding', 'fileformat'},
        lualine_y = {'diff', 'diagnostics'},
        lualine_z = {'progress'},
      },
     inactive_sections = {
        lualine_a = {'mode'},
        lualine_b = {'location'},
        --lualine_c = {Util.lualine.root_dir(),'filename',Util.lualine.pretty_path({relative="root",})},
        lualine_c = {Util.lualine.pretty_path({relative="root",})},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = { 'filetype', 'encoding', 'fileformat'},
        lualine_y = {'diff', 'diagnostics'},
        lualine_z = {'progress'},
      },
    },
  },
}
