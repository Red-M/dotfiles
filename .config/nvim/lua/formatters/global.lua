
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})


return {

  {
    "stevearc/conform.nvim",
    -- dependencies = { "mason.nvim" },
    -- optional = true,
      keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
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
  },
}
