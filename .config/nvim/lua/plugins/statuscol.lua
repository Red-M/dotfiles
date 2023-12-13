return {
  "luukvbaal/statuscol.nvim",
  lazy = false,
  priority = 700,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      ft_ignore = { "neo-tree" },
      segments = {
        {text = { "%C " }, click = "v:lua.ScFa"}, -- Fold
        {
          -- line number
          text = { builtin.lnumfunc, "" },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
        {text = { "%s" }, click = "v:lua.ScSa"}, -- Sign
      },
    })
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = vim.api.nvim_create_augroup("statuscol",{clear = false}),
      callback = function()
        if vim.bo.filetype == "neo-tree" then
          vim.opt_local.statuscolumn = ""
        end
      end,
    })
  end,
}

