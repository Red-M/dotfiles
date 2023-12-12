return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "python",
        "bash",
        "c",
        "cpp",
        "lua",
        "markdown",
        "markdown_inline",
        "diff",
        "yaml",
        "json",
        "jq",
        "json5",
        "kconfig",
        "make",
        "cmake",
        "ninja",
        "perl",
        "php",
        "phpdoc",
        "sql",
        "ssh_config",
        "dockerfile",
        "regex",
        "vim",
        "vimdoc",
        "toml",
        "terraform",
        "hcl",
        "go",
        "javascript",
        "html"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true },
    })
    require("nvim-treesitter.install").prefer_git = true
  end
}
