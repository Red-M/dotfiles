return {
  "Red_M/midnightokai.nvim",
  dev = true,
  enabled = true,
  lazy = false,
  priority = 2000,
  config = function()
    require("monokai-pro").setup({
      filter = "classic",
      styles = {
        comment = { italic = false },
        keyword = { italic = false }, -- any other keyword
        type = { italic = false }, -- (preferred) int, long, char, etc
        storageclass = { italic = false }, -- static, register, volatile, etc
        structure = { italic = false }, -- struct, union, enum, etc
        parameter = { italic = false }, -- parameter pass in function
        annotation = { italic = false },
        tag_attribute = { italic = false }, -- attribute of tag in reactjs
      },
      overridePalette = function(name)
        return {
          dark2 = "#272822",
          dark1 = "#383830",
          background = "#272822",
          text = "#f5f4f1",
          accent1 = "#f92672",
          accent2 = "#fd971f",
          accent3 = "#e6db74",
          accent4 = "#a6e22e",
          accent5 = "#9effff",
          accent6 = "#ae81ff",
          dimmed1 = "#c0c1b5",
          dimmed2 = "#919288",
          dimmed3 = "#6e7066",
          dimmed4 = "#57584f",
          dimmed5 = "#3b3c35",
        }
      end,
      override = function(c)
        return {
          LocalHighlight = { bg = c.editor.findMatchHighlightBackground },
          Bold = { bold = false },
          -- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|
          Italic = { italic = false },
          Todo = {
            bg = c.editor.background,
            fg = c.base.magenta,
            bold = false,
          },
        }
      end,
    })
    vim.cmd([[colorscheme monokai-pro]])
  end,
}
