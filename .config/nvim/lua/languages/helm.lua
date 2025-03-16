return {
  { "towolf/vim-helm", ft = "helm" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "helm" } },
  },
  {
    -- "ngalaiko/tree-sitter-go-template",
    "kmoschcau/tree-sitter-go-template",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
}
