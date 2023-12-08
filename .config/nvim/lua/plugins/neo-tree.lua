return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, position = "left", dir = Util.get_root() })
      end,
      desc = "Explorer (root dir)",
      remap = true,
    },
    {
      "<leader>E",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          position = "float",
          dir = Util.get_root(),
        })
      end,
      desc = "Explorer Float (root dir)",
    },
  },
--~   opts = require("tvl.config.neo-tree"),
  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
        vim.cmd([[set showtabline=0]])
      end
    end
  end,
}