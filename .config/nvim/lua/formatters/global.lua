
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

function M.format_user_command(args,value)
  if args.bang then
    vim.b.enable_autoformat = value
  else
    vim.g.enable_autoformat = value
  end
end

function M.invert_bool(input)
  if input == nil then
    return true
  else
    return (not input)
  end
end

vim.api.nvim_create_user_command("Format",
  function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
  end,
  { range = true }
)

vim.api.nvim_create_user_command("FormatDisable",
  function(args) M.format_user_command(args,false) end,
  {
    desc = [[Disable autoformat-on-save globally or for this buffer with !]],
    bang = true,
  }
)

vim.api.nvim_create_user_command("FormatEnable",
  function(args) M.format_user_command(args,true) end,
  {
    desc = [[Enable autoformat-on-save globally or for this buffer with !]],
    bang = true,
  }
)

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("plugin_conform_format_on_save",{clear = false}),
  pattern = {"*"},
  callback = function(data)
    if vim.g.enable_conform == nil or vim.g.enable_conform == true then
      local save_cursor = vim.fn.getpos(".")
      if (not vim.g.enable_autoformat == false) or (vim.b.enable_autoformat == true) then
        require("conform").format({ bufnr = data.buf })
      else
        require("conform").format({ bufnr = data.buf, formatters = { "injected" }, timeout_ms = 3000 })
      end
      vim.fn.setpos(".", save_cursor)
    end
  end,
})


return {
  {
    "stevearc/conform.nvim",
    -- dependencies = { "mason.nvim" },
    -- optional = true,
    lazy = false,
    keys = {
      {
        "<leader>cC",
        function()
          vim.g.enable_conform = not M.invert_bool(vim.g.enable_autoformat)
        end,
        mode = { "n", "v" },
        desc = "Toggle conform.nvim autoformat-on-save",
      },
      {
        "<leader>cE",
        function()
          vim.g.enable_autoformat = M.invert_bool(vim.g.enable_autoformat)
        end,
        mode = { "n", "v" },
        desc = "Toggle global autoformat-on-save",
      },
      {
        "<leader>ce",
        function()
          vim.b.enable_autoformat = M.invert_bool(vim.b.enable_autoformat)
        end,
        mode = { "n", "v" },
        desc = "Toggle buffer autoformat-on-save",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format file",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format file with injected langs",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        ["*"] = {
          "injected",
          -- "trim_newlines",
          "trim_whitespace",
        },
      },
      lang_to_ext = {
        bash = "sh",
        c_sharp = "cs",
        elixir = "exs",
        javascript = "js",
        julia = "jl",
        latex = "tex",
        markdown = "md",
        python = "py",
        ruby = "rb",
        rust = "rs",
        teal = "tl",
        typescript = "ts",
      },
      lang_to_formatters = {},
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },

      -- -- if format_on_save is a function, it will be called during BufWritePre
      -- format_on_save = function(bufnr)
      --   -- Disable autoformat on certain filetypes
      --   local ignore_filetypes = vim.g.utils_ft['default']
      --   if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      --     return
      --   end
      --   -- Disable with a global or buffer-local variable
      --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      --     return
      --   end
      --   -- Disable autoformat for files in a certain path
      --   -- local bufname = vim.api.nvim_buf_get_name(bufnr)
      --   -- if bufname:match("/node_modules/") then
      --   --   return
      --   -- end
      --   -- ...additional logic...
      --   return { timeout_ms = 3000, lsp_format = "fallback" }
      -- end,
      --
      -- -- There is a similar affordance for format_after_save, which uses BufWritePost.
      -- -- This is good for formatters that are too slow to run synchronously.
      -- format_after_save = function(bufnr)
      --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      --     return
      --   end
      --   return { lsp_format = "fallback" }
      -- end,

    },
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}

