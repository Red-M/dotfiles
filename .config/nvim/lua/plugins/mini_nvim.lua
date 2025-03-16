local opts = {
  ["operators"] = function(plugin)
    return {}
  end,
  ["surround"] = function(plugin)
    return {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    }
  end,
  ["indentscope"] = function(plugin)
    return {
      symbol = "┊",
      draw = {
        animation = plugin.gen_animation.none()
      },
      options = { try_as_border = false },
    }
  end,
}

return {
  {
    'echasnovski/mini.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    keys = function(_, keys)
      local surround = opts.surround(nil)
      local mappings = {
        { surround.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
        { surround.mappings.delete, desc = "Delete Surrounding" },
        { surround.mappings.find, desc = "Find Right Surrounding" },
        { surround.mappings.find_left, desc = "Find Left Surrounding" },
        { surround.mappings.highlight, desc = "Highlight Surrounding" },
        { surround.mappings.replace, desc = "Replace Surrounding" },
        { surround.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    config = function()
      for key, value in pairs(opts) do
        local plugin = require('mini.'..key)
        plugin.setup(value(plugin))
      end
    end,
  },
}
