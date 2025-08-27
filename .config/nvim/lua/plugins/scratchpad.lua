return {
  {
    "folke/snacks.nvim",
    opts = {
      scratch = {
        filekey = {
          cwd = true, -- use current working directory
          branch = false, -- use current branch name
          count = true, -- use vim.v.count1
        },
      },
      styles = {
        scratch = {
          width = 0.5,
          height = 0.8,
        },
      },
    },
    keys = {
      { "<leader>cc",  function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>.",  function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>cC",  function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
    },
  },
}

