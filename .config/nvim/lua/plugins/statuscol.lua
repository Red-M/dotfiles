return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  priority = 700,
  --event = { "BufReadPost", "BufNewFile", "LazyFile" },
  -- event = { "BufReadPost", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      -- ft_ignore = { "neo-tree" },
      segments = {
        {text = { "%C " }, click = "v:lua.ScFa"}, -- Fold
        {
          -- line number
          text = { builtin.lnumfunc },
          -- condition = { true, },
          click = "v:lua.ScLa",
        },
        -- {text = { "%s" }, click = "v:lua.ScSa", condition={true,}, }, -- Sign
        {text = { "%s" }, click = "v:lua.ScSa", }, -- Sign
      },
    })
    -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
    --   group = vim.api.nvim_create_augroup("statuscol",{clear = false}),
    --   callback = function()
    --     if vim.bo.filetype == "neo-tree" then
    --       vim.api.nvim_exec([[silent setlocal rnu]], false)
    --       vim.api.nvim_win_set_option(0, 'relativenumber', true)
    --       vim.wo.relativenumber = true
    --       vim.opt_local.statuscolumn = true
    --       {
    --        relculright = true,
    --        {text = { builtin.lnumfunc }, click = "v:lua.ScLa"}, -- Fold
    --       }
    --     end
    --   end,
    -- })
  end,
}

