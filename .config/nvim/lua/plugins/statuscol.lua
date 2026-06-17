return {
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    priority = 700,
    --event = { "BufReadPost", "BufNewFile", "LazyFile" },
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          {text = { "%C" }, click = "v:lua.ScFa", }, -- Fold
          {text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
          -- {text = { "%s" }, click = "v:lua.ScSa", condition={true,}, }, -- Sign
          {text = { "%s" }, click = "v:lua.ScSa", }, -- Sign
        },
      })
    end,
  },
}


