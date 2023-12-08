return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "python",
        "bash",
        "c",
        "yaml",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "regex",
        "vim",
        "vimdoc",
        "hcl",
        "javascript",
        "html"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true },
    })
  end
 }