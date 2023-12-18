local colors = require("base46").get_theme_tb "base_30"

return {
  nvUpdaterTitle = { fg = colors.black, bg = colors.orange },
  nvUpdaterTitleDone = { fg = colors.black, bg = colors.green },
  nvUpdaterTitleFAIL = { fg = colors.black, bg = colors.red },

  nvUpdaterProgress = { fg = colors.red, bg = colors.one_bg2 },
  nvUpdaterProgressDONE = { fg = colors.green, bg = colors.one_bg2 },
  nvUpdaterProgressFAIL = { fg = colors.red, bg = colors.one_bg2 },

  nvUpdaterCommits = { fg = colors.green },
  nvUpdaterFAIL = { fg = colors.red },
}
