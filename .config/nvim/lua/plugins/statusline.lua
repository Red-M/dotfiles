--local Util = require("lazyvim.util")
local midnightokai = {
  normal = {
    a = { bg = "#e6db74", fg = "#272822" },
    b = { bg = "#30312b", fg = "#e6db74" },
    c = { bg = "#30312b", fg = "#c0c1b5" },
    x = { bg = "#30312b", fg = "#c0c1b5" },
  },
  insert = {
    a = { bg = "#a6e22e", fg = "#272822" },
    b = { bg = "#30312b", fg = "#a6e22e" },
  },
  command = {
    a = { bg = "#fd971f", fg = "#272822" },
    b = { bg = "#30312b", fg = "#fd971f" },
  },
  visual = {
    a = { bg = "#ae81ff", fg = "#272822" },
    b = { bg = "#30312b", fg = "#ae81ff" },
  },
  replace = {
    a = { bg = "#f92672", fg = "#272822" },
    b = { bg = "#30312b", fg = "#f92672" },
  },
  inactive = {
    a = { bg = "#272822", fg = "#e6db74" },
    b = { bg = "#272822", fg = "#e6db74" },
    c = { bg = "#272822", fg = "#c0c1b5" },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      { "folke/noice.nvim", }
    },
    opts = {
      options = {
        theme = midnightokai,
        globalstatus = false,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        extensions = {'lazy', 'man', 'nvim-tree'},
      },
      sections = {
        lualine_a = {
          {'mode', separator = { right = '', left = nil }},
          { require("noice").api.status.mode.get, cond = require("noice").api.status.mode.has, color = { bg = "#c40000" }, separator = { right = '', left = nil },},
        },
        lualine_b = {'location', 'progress'},
        --lualine_c = {Util.lualine.root_dir(),'filename',Util.lualine.pretty_path({relative="root",})},
        -- lualine_c = {Util.lualine.pretty_path({relative="root",})},
        lualine_c = {{'filename',path=3,newfile_status=true}},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = {'encoding'},
        lualine_y = {'diff', 'filetype', 'diagnostics'},
        lualine_z = {'fileformat'},
      },
      inactive_sections = {
        lualine_a = {'mode'},
        lualine_b = {'location'},
        --lualine_c = {Util.lualine.root_dir(),'filename',Util.lualine.pretty_path({relative="root",})},
        -- lualine_c = {Util.lualine.pretty_path({relative="root",})},
        lualine_c = {{'filename',path=3,newfile_status=true}},
        -- lualine_x = { treesitter_status_line, 'filetype', 'encoding', 'fileformat'},
        lualine_x = {'encoding'},
        lualine_y = {'diff', 'filetype', 'diagnostics'},
        lualine_z = {'fileformat'},
      },
    },
  },
}
