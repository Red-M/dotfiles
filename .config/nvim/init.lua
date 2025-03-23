-- vim.cmd([[
-- call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
-- " Plug 'tpope/vim-scriptease'
-- " Plug 'tpope/vim-repeat'
-- call plug#end()
-- ]])

vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lazy/base46")

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

-- Core configs loaded from ./lua/core/
--require("core.options")

--package.loaded["lazyvim.config.options"] = true

vim.api.nvim_create_autocmd({ "UIEnter", "TabNewEntered" }, {
  group = vim.api.nvim_create_augroup("always_show_neotree", { clear = true }),
  -- once = true,
  callback = function(data)
    if not vim.g.neotree_opened then
      require("neo-tree.command").execute({ action = "show" })
      vim.g.neotree_opened = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = vim.api.nvim_create_augroup("always_show_neotree2", { clear = true }),
  -- once = true,
  callback = function(data)
    -- vim.print(data)
    -- This needs to ignore checkhealth tab changes, otherwise checkhealth will crash
    -- if not vim.g.neotree_opened then
    require("neo-tree.command").execute({ action = "show" })
    vim.g.neotree_opened = true
    -- end
  end,
})

require("config.options")

-- Plugins configured at ./lua/plugins/
require("lazy").setup({
  spec = {
    { import = "themes" },
    -- {
    --   "LazyVim/LazyVim",
    --   -- import = "lazyvim.plugins",
    --   opts = {
    --     colorscheme = "monokai-pro",
    --     news = {
    --       -- When enabled, NEWS.md will be shown when changed.
    --       -- This only contains big new features and breaking changes.
    --       lazyvim = true,
    --       -- Same but for Neovim's news.txt
    --       neovim = true,
    --     },
    --   },
    -- },
    --{ import = "lazyvim_extras" },
    { import = "languages" },
    { import = "formatters" },
    { import = "plugins" },
    { import = "plugs" },
    { import = "games" },
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

require("config.keymaps")

