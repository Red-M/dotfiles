return {
{
  "nvim-treesitter/nvim-treesitter",
  -- branch = "main",
  branch = "master", -- a rewrite is happening, check the main branch if this disappears
  lazy = false,
  --priority = 500,
  build = ":TSUpdate",
--   event = { "LazyFile", "VeryLazy" },
  event = { "VeryLazy" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
    require("nvim-treesitter.install").prefer_git = true
  end,
  opts = {
    ensure_installed = {
      "arduino",
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
      "ini",
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
    sync_install = false,
    highlight = { enable = true, use_languagetree = true, },
    indent = { enable = true },
    context_commentstring = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
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
},
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "VeryLazy",
  enabled = true,
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
