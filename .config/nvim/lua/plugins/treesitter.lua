return {
  "nvim-treesitter/nvim-treesitter",
  --lazy = false,
  --priority = 500,
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "cpp",
      "diff",
      "dockerfile",
      "go",
      -- "gotmpl",
      "hcl",
      "html",
      "javascript",
      "jq",
      "json",
      "json5",
      "jsonc",
      "kconfig",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "ninja",
      "perl",
      "php",
      "phpdoc",
      "python",
      "regex",
      "rst",
      "ruby",
      "sql",
      "ssh_config",
      "terraform",
      "toml",
      "vim",
      "vimdoc",
      "yaml",
    },
    sync_install = false,
    highlight = { enable = true, use_languagetree = true, },
    indent = { enable = true },
    context_commentstring = { enable = true },
    --parser_install_dir = vim.fn.stdpath("config") .. "/treesitter_parsers",
  },
  config = function (plugin, opts)
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    -- parser_config.gotmpl = {
    --   install_info = {
    --     url = "https://github.com/ngalaiko/tree-sitter-go-template",
    --     -- url = "https://github.com/qvalentin/tree-sitter-go-template",
    --     files = { "src/parser.c" },
    --     -- branch = { "feat/helm-lang" },
    --   },
    --   filetype = "gotmpl",
    --   used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"},
    -- }
    -- parser_config.helm = {
    --   install_info = {
    --     -- url = "https://github.com/ngalaiko/tree-sitter-go-template",
    --     url = "https://github.com/qvalentin/tree-sitter-go-template",
    --     files = { "src/parser.c" },
    --     branch = { "feat/helm-lang" },
    --   },
    --   filetype = "gotmpl",
    --   used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"},
    -- }

    require("nvim-treesitter.configs").setup(opts)
  end
}
