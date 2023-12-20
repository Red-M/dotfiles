vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lazy/base46")

local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Core configs loaded from ./lua/core/
--require("core.options")

--package.loaded["lazyvim.config.options"] = true

-- Plugins configured at ./lua/plugins/
require("lazy").setup({
	spec = {
		{
      "LazyVim/LazyVim", import = "lazyvim.plugins",
      opts = {
        colorscheme = "monokai-pro",
        news = {
          -- When enabled, NEWS.md will be shown when changed.
          -- This only contains big new features and breaking changes.
          lazyvim = true,
          -- Same but for Neovim's news.txt
          neovim = true,
        },
      },
    },
		{ import = "plugins" },
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
	install = { colorscheme = { "monokai-pro", "habamax" } },
	checker = { enabled = true }, -- automatically check for plugin updates
	root = vim.fn.stdpath("config") .. "/lazy/plugins",
	state = vim.fn.stdpath("config") .. "/lazy/state.json",
	install = { colorscheme = { colorscheme = { "monokai-pro", "habamax" } } },
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

--require("config.options")

