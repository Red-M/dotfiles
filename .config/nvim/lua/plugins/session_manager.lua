vim.opt.sessionoptions = { -- required
  "buffers",
  "tabpages",
  "globals",
}

return {
  {
    -- "stevearc/resession.nvim",
    "Dom324/resession.nvim",
    version = "fix-gitsigns-lsp",
    enabled = not vim.g.nvimpager,
    lazy = false,
    priority = -2000,
    dependencies = {
      {
        "tiagovla/scope.nvim",
        lazy = false,
        config = true,
      },
    },
    opts = {
      autosave = {
        enabled = true,
        interval = 60,
        notify = false,
      },
      extensions = {
        scope = {},
        -- barbar = {},
      },
      buf_filter = function(bufnr)
        local buf_options = vim.bo[bufnr]
        local buftype = buf_options.buftype
        local bufft = buf_options.filetype
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        if buftype == 'help' then
          return true
        end
        if buf_options.bufhidden == "hide" then
          return false
        end
        if string.match(bufname,"Scratch%%%7") then
          return false
        end
        if string.match(bufname,"buffer_manager%-menu$") or buftype == "buffer_manager" then
          return false
        end
        if buftype ~= "" and buftype ~= "acwrite" then
          return false
        end
        if bufname == "" then
          return false
        end

        -- this is required, since the default filter skips nobuflisted buffers
        return true
      end,
    },
    config = function(_, opts)
      local resession = require('resession')
      resession.setup(opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("plugin_resession",{clear = false}),
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            -- Save these to a different directory, so our manual sessions don't get polluted
            resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("plugin_resession",{clear = false}),
        callback = function()
          if vim.fn.argc(-1) == 0 then
            resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
          end
        end,
      })

      -- vim.api.nvim_create_autocmd("VimLeavePre", {
      --   callback = function()
      --     -- Always save a special session named "last"
      --     resession.save("last")
      --   end,
      -- })
      vim.keymap.set('n', '<leader>ss', resession.save)
      vim.keymap.set('n', '<leader>sl', resession.load)
      vim.keymap.set('n', '<leader>sd', resession.delete)
    end,
  },
}
