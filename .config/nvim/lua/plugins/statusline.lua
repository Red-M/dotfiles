--local nv_statusline = require("nvim-treesitter.statusline")
-- local treesitter_status_line = function()
--   return nv_statusline.statusline({
--     -- type_patterns = {".*",},
--   })
-- end
local Util = require("lazyvim.util")

return {
  {
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
        -- lualine_c = {Util.lualine.pretty_path({relative="root",})},
        lualine_c = {{'filename',path=3,newfile_status=true}},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = { 'filetype', 'encoding', 'fileformat'},
        lualine_y = {'diff', 'diagnostics'},
        lualine_z = {'progress'},
      },
     inactive_sections = {
        lualine_a = {'mode'},
        lualine_b = {'location'},
        --lualine_c = {Util.lualine.root_dir(),'filename',Util.lualine.pretty_path({relative="root",})},
        -- lualine_c = {Util.lualine.pretty_path({relative="root",})},
        lualine_c = {{'filename',path=3,newfile_status=true}},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = { 'filetype', 'encoding', 'fileformat'},
        lualine_y = {'diff', 'diagnostics'},
        lualine_z = {'progress'},
      },
    },
  },
}
