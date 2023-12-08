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
require("core.options")

-- Plugins configured at ./lua/plugins/
require("lazy").setup(
  {{import = "plugins"}},
  {
    root=vim.fn.stdpath("config") .. "/lazy/plugins",
    state=vim.fn.stdpath("config") .. "/lazy/state.json",
    install={colorscheme={colorscheme = { "monokai-pro", "habamax" }},},
  }
)

