local function refresh_filetypes()
  -- Enable treesitter only for filetypes supported by installed parsers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = vim .iter(require("nvim-treesitter").get_installed()):map(vim.treesitter.language.get_filetypes):flatten():totable(),
    group = vim.api.nvim_create_augroup("treesitter_support", { clear = true }),
    callback = function()
      vim.wo.foldexpr = "v:lua.require'nvim-treesitter'.foldexpr()"
      vim.treesitter.start()
    end,
  })
end

return {
{
  "nvim-treesitter/nvim-treesitter",
  enabled = not vim.g.nvimpager,
  branch = "main",
  commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
  version = false, -- last release is way too old and doesn't work on Windows
  build = function()
    local TS = require("nvim-treesitter")
    if not TS.get_installed then
      vim.health.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
      return
    end
    -- LazyVim.treesitter.build(function()
    TS.update(nil, { summary = true })
    -- end)
  end,
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  lazy = false,
  build = ":TSUpdate",
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    -- require("nvim-treesitter.query_predicates")
    require("nvim-treesitter.install").prefer_git = true
  end,
  opts_extend = { "ensure_installed" },
  opts = {
    -- sync_install = false,
    ensure_installed = {
      "arduino",
      "bash",
      "c",
      "c_sharp",
      "cmake",
      "cpp",
      "diff",
      "dockerfile",
      "go",
      -- "gotmpl",
      "hcl",
      "helm",
      "html",
      "ini",
      "javascript",
      "jq",
      "json",
      "json5",
      -- "jsonc",
      "kconfig",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "ninja",
      "nix",
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
    -- highlight = { enable = true, use_languagetree = true, },
    -- indent = { enable = true },
    -- context_commentstring = { enable = true },
    -- incremental_selection = {
    --     enable = true,
    --     keymaps = {
    --       init_selection = "<C-space>",
    --       node_incremental = "<C-space>",
    --       scope_incremental = false,
    --       node_decremental = "<bs>",
    --     },
    --   },
      -- textobjects = {
      --   move = {
      --     enable = true,
      --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      --   },
      -- },
    --parser_install_dir = vim.fn.stdpath("config") .. "/treesitter_parsers",
  },
  config = function (plugin, opts)
    local treesitter = require("nvim-treesitter")

    treesitter.install(opts.ensure_installed):await(function(err, success)
      if not err and success then
        refresh_filetypes()
      end
    end)
  end,
},
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  -- event = "VeryLazy",
  enabled = false,
  config = function()
    -- If treesitter is already loaded, we need to run config again for textobjects
    -- if LazyVim.is_loaded("nvim-treesitter") then
    --   local opts = LazyVim.opts("nvim-treesitter")
    --   require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
    -- end

    -- When in diff mode, we want to use the default
    -- vim text objects c & C instead of the treesitter ones.
    local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
    local configs = require("nvim-treesitter.configs")
    for name, fn in pairs(move) do
      if name:find("goto") == 1 then
        move[name] = function(q, ...)
          if vim.wo.diff then
            local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
            for key, query in pairs(config or {}) do
              if q == query and key:find("[%]%[][cC]") then
                vim.cmd("normal! " .. key)
                return
              end
            end
          end
          return fn(q, ...)
        end
      end
    end
  end,
},
}

