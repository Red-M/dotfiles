return {
  "lewis6991/gitsigns.nvim",
  --event = { "BufReadPost", "BufNewFile", "LazyFile" },
  event = { "BufReadPost", "BufNewFile" },
  -- init = function()
  -- load gitsigns only when a git file is opened
  --vim.api.nvim_create_autocmd({ "BufRead" }, {
  --group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
  --callback = function()
  -- vim.fn.jobstart({"git", "-C", vim.loop.cwd(), "rev-parse"},
  --  {
  --   on_exit = function(_, return_code)
  --    if return_code == 0 then
  --    vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
  --  vim.schedule(function()
  --  require("lazy").load { plugins = { "gitsigns.nvim" } }
  --  end)
  --  end
  -- end
  -- }
  -- )
  --end,
  -- })
  --end,
  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "┃" },
      untracked = { text = "┃" },
    },
  }
  --   on_attach = function(bufnr)
  --     local gs = package.loaded.gitsigns
  --
  --     local function map(mode, l, r, opts)
  --       opts = opts or {}
  --       opts.buffer = bufnr
  --       vim.keymap.set(mode, l, r, opts)
  --     end
  --
  --     -- Navigation
  --     map('n', ']c', function()
  --       if vim.wo.diff then return ']c' end
  --       vim.schedule(function() gs.next_hunk() end)
  --       return '<Ignore>'
  --     end, {expr=true})
  --
  --     map('n', '[c', function()
  --       if vim.wo.diff then return '[c' end
  --       vim.schedule(function() gs.prev_hunk() end)
  --       return '<Ignore>'
  --     end, {expr=true})
  --
  --     -- Actions
  --     map('n', '<leader>hs', gs.stage_hunk)
  --     map('n', '<leader>hr', gs.reset_hunk)
  --     map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
  --     map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
  --     map('n', '<leader>hS', gs.stage_buffer)
  --     map('n', '<leader>hu', gs.undo_stage_hunk)
  --     map('n', '<leader>hR', gs.reset_buffer)
  --     map('n', '<leader>hp', gs.preview_hunk)
  --     map('n', '<leader>hb', function() gs.blame_line{full=true} end)
  --     map('n', '<leader>tb', gs.toggle_current_line_blame)
  --     map('n', '<leader>hd', gs.diffthis)
  --     map('n', '<leader>hD', function() gs.diffthis('~') end)
  --     map('n', '<leader>td', gs.toggle_deleted)
  --
  --     -- Text object
  --     map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  --   end,
  -- },
}
