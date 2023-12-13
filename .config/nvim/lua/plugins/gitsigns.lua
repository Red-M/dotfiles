return {
  "lewis6991/gitsigns.nvim",
  init = function()
    -- load gitsigns only when a git file is opened
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
      callback = function()
        vim.fn.jobstart({"git", "-C", vim.loop.cwd(), "rev-parse"},
          {
            on_exit = function(_, return_code)
              if return_code == 0 then
                vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                vim.schedule(function()
                  require("lazy").load { plugins = { "gitsigns.nvim" } }
                end)
              end
            end
          }
        )
      end,
    })
  end,
  opts = {},
}
