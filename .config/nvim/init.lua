
vim.g.nvimpager = type(nvimpager) == "table"

-- vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lazy/base46")

local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugins configured at ./lua/plugins/
require("lazy").setup({
  spec = {
    { import = "themes" },
    vim.g.nvimpager and {} or { import = "languages" },
    vim.g.nvimpager and {} or { import = "formatters" },
    { import = "plugins" },
    { import = "plugs" },
    vim.g.nvimpager and {} or { import = "games" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "midnightokai", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  root = vim.fn.stdpath("config") .. "/lazy/plugins",
  state = vim.fn.stdpath("config") .. "/lazy/state.json",
  install = { colorscheme = { colorscheme = { "midnightokai", "habamax" } } },
  dev = { path = vim.fn.stdpath("config") .. "/local_plugins" },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("config.lazy")

