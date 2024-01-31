local Util = require("lazyvim.util")

return {
  {
    "nvim-lualine/lualine.nvim",
    --lazy = false,
    opts = {
      options = {
        globalstatus = false,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {'mode',separator = { right = '', left = '' }},
          { require("noice").api.status.mode.get, cond = require("noice").api.status.mode.has, color = { bg = "#c40000" },separator = { right = '', left = '' },},
        },
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
