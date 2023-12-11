return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    globalstatus = false,
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'location'},
      lualine_c = {'filename'},
      lualine_z = {'progress'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'diff', 'diagnostics'}
    },
  }
}
