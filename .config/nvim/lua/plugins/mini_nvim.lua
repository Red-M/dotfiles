local opts = {
  ["bufremove"] = function(plugin)
    return {}
  end,
  ["splitjoin"] = function(plugin)
    return {}
  end,
  ["operators"] = function(plugin)
    return {}
  end,
  -- This handles i and a operators, eg, dii (delete inside indent)
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
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
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
    'nvim-mini/mini.nvim',
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
        {
          "<leader>bd",
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end,
          desc = "Delete Buffer",
        },
        { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
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
