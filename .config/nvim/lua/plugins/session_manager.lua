vim.opt.sessionoptions = { -- required
  "buffers",
  "tabpages",
  "globals",
}

return {
  -- 'Shatur/neovim-session-manager',
  --  enabled = false,
  --   config = function()
  --   local Path = require('plenary.path')
  --   local config = require('session_manager.config')
  --   require('session_manager').setup({
  --   sessions_dir = Path:new(vim.fn.stdpath('config'), 'sessions'), -- The directory where the session files will be saved.
  --   session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
  --   dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.loop.cwd()` if the passed `dir` is `nil`.
  --   autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  --   autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  --   autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  --   autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
  --   autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
  --     'gitcommit',
  --     'gitrebase',
  --   },
  --   autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
  --   autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  --   max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
  -- }) end,

  {
    "stevearc/resession.nvim",
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
        local buftype = vim.bo[bufnr].buftype
        if buftype == 'help' then
          return true
        end
        if buftype ~= "" and buftype ~= "acwrite" then
          return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == "" then
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
