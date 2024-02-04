return {
  {
    -- "~/git/midnightokai.nvim",
    -- dev = true,
    "Red-M/monokai-pro.nvim",
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
          -- local monokai_palette = require("monokai-pro.colorscheme.palette." .. name)
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
        overrideColorscheme = function(cs, p, config, hp)
          -- local cs = {}
          local calc_bg = hp.blend(p.background, 0.75, '#000000')
          cs.editor = {
            background = config.transparent_background and "NONE" or calc_bg,
            foreground = p.text,
            lineHighlightBackground = hp.blend(p.accent2, 0.15, calc_bg), -- "#fcfcfa0c", -- background: background
            selectionBackground = hp.blend(p.dimmed1, 0.35, calc_bg), --"#c1c0c027", -- background: background
            findMatchBackground = hp.blend(p.accent2, 0.35, calc_bg), -- "#fcfcfa26", -- background: background
            findMatchBorder = p.accent3,
            findMatchHighlightBackground = hp.blend(p.accent2, 0.35, calc_bg), -- "#fcfcfa26", -- background: background
            foldBackground = hp.blend(p.text, 0.35, calc_bg), -- "#fcfcfa0c", -- background: background
            wordHighlightBackground = hp.blend(p.accent2, 0.35, calc_bg), -- "#fcfcfa26", -- illuminateRead
            selectionHighlightBackground = hp.blend(p.accent2, 0.35, calc_bg), -- "#fcfcfa26", -- illuminateText
            wordHighlightStrongBackground = hp.blend(p.accent2, 0.35, calc_bg), -- "#fcfcfa26", -- illuminateWrite
            statuscolBackground = hp.blend(p.dimmed5, 0.75, calc_bg),
          }

          cs.editorLineNumber = {
            foreground = hp.blend(p.dimmed1, 0.75, p.dimmed2),
            activeForeground = hp.blend(p.text, 0.95, p.dimmed1),
          }

          cs.editorHoverWidget = {
            background = p.dimmed5,
            border = calc_bg,
          }

          cs.editorSuggestWidget = {
            background = p.dimmed5, -- "#403e41",
            border = p.dimmed5, -- "#403e41",
            foreground = p.dimmed1, -- "#c1c0c0",
            highlightForeground = p.text, -- "#fcfcfa",
            selectedBackground = p.dimmed3, -- "#727072",
          }

          cs.editorIndentGuide = {
            background = calc_bg, -- "#403e41",
            activeBackground = p.dimmed3, -- "#5b595c",
          }

          cs.editorInlayHint = {
            background = hp.blend(p.accent2, 0.3, calc_bg),
            foreground = hp.lighten(p.dimmed2, 3),
          }

          cs.editorGutter = {
            addedBackground = p.accent4, -- "#a9dc76",
            deletedBackground = p.accent1, -- "#ff6188",
            modifiedBackground = p.accent2, -- "#fc9867",
          }

          cs.sideBar = {
            background = p.dark2, -- "#221f22",
            foreground = p.dimmed2, -- "#939293",
          }

          cs.sideBarTitle = {
            foreground = p.dimmed4, -- "#5b595c",
          }

          cs.list = {
            activeSelectionBackground = hp.blend(p.text, 0.11, cs.sideBar.background), -- "#fcfcfa1c", -- background: sideBarBackground,
          }

          cs.sideBarSectionHeader = {
            background = p.dark1, -- "#221f22",
            foreground = p.dimmed1, -- "#c1c0c0",
          }

          cs.breadcrumb = {
            foreground = p.dimmed2, -- "#939293",
          }

          cs.button = {
            background = p.dimmed5, -- "#403e41",
            foreground = p.dimmed1, -- "#c1c0c0",
            hoverBackground = p.dimmed4, -- "#5b595c",
            separator = calc_bg, -- "#272822",
          }

          cs.scrollbarSlider = {
            hoverBackground = hp.blend(p.dimmed1, 0.15, calc_bg), -- "#c1c0c026", -- background: background
          }

          cs.gitDecoration = {
            addedResourceForeground = p.accent4, -- "#a9dc76",
            conflictingResourceForeground = p.accent2, -- "#fc9867",
            deletedResourceForeground = p.accent1, -- "#ff6188",
            ignoredResourceForeground = p.dimmed4, -- "#5b595c",
            modifiedResourceForeground = p.accent3, -- "#ffd866",
            stageDeletedResourceForeground = p.accent1, -- "#ff6188",
            stageModifiedResourceForeground = p.accent3, -- "#ffd866",
            untrackedResourceForeground = p.dimmed2, -- "#c1c0c0",
          }

          cs.inputValidation = {
            errorBackground = p.dimmed5, -- "#403e41",
            errorBorder = p.accent1, -- "#ff6188",
            errorForeground = p.accent1, --"#ff6188",
            infoBackground = p.dimmed5, -- "#403e41",
            infoBorder = p.accent5, --"#78dce8",
            infoForeground = p.accent5, --"#78dce8",
            warningBackground = p.dimmed5, --"#403e41",
            warningBorder = p.accent2, --"#fc9867",
            warningForeground = p.accent2, --"#fc9867",
          }

          cs.errorLens = {
            errorBackground = hp.blend(p.accent1, 0.1),
            errorForeground = p.accent1,
            warningBackground = hp.blend(p.accent2, 0.1),
            warningForeground = p.accent2,
            infoBackground = hp.blend(p.accent5, 0.1),
            infoForeground = p.accent5,
            hintBackground = hp.blend(p.accent5, 0.1),
            hintForeground = p.accent5,
          }

          cs.terminal = {
            background = p.dimmed5, -- "#403e41",
            foreground = p.text, -- "#fcfcfa",
          }

          cs.terminalCursor = {
            background = "#ffffff", -- "#00000000",
            foreground = p.text, -- "#fcfcfa",
          }

          cs.editorGroupHeader = {
            tabsBackground = p.dark1, -- "#221f22",
            tabsBorder = p.dark1, -- "#221f22",
          }

          cs.tab = {
            activeBackground = config.transparent_background and "NONE" or calc_bg, -- "#272822",
            activeBorder = p.accent3, -- "#ffd866",
            activeForeground = p.accent1, -- "#ffd866",
            inactiveBackground = hp.blend(calc_bg, 0.65, '#000000'), --hp.lighten(calc_bg, 15),
            inactiveForeground = p.dimmed3, -- "#939293",
            unfocusedActiveBackground = p.dark2, -- "#272822",
            unfocusedActiveBorder = p.dimmed2, -- "#939293",
            unfocusedActiveForeground = p.dimmed1, -- "#c1c0c0",
          }

          cs.statusBar = {
            -- background = p.dark1,
            background = p.dark2,
            foreground = p.dimmed3,
            activeForeground = p.dimmed1,
          }

          cs.diffEditor = {
            insertedLineBackground = hp.blend(p.accent4, 0.1, p.dark1), -- #a9dc7619
            removedLineBackground = hp.blend(p.accent1, 0.1, p.dark1), -- #ff618819
            modifiedLineBackground = hp.blend(p.accent2, 0.1, p.dark1), -- #fc986719
          }

          cs.diffEditorOverview = {
            insertedForeground = hp.blend(p.accent4, 0.65, cs.diffEditor.insertedLineBackground), -- #a9dc76a5
            removedForeground = hp.blend(p.accent1, 0.65, cs.diffEditor.removedLineBackground), -- #ff6188a5
            modifiedForeground = hp.blend(p.accent2, 0.65, cs.diffEditor.modifiedLineBackground), -- #fc9867a5
          }

          cs.notifications = {
            background = p.dimmed5,
            border = p.dimmed5,
            foreground = p.dimmed1,
          }
          cs.notificationsErrorIcon = {
            foreground = p.accent1,
          }
          cs.notificationsInfoIcon = {
            foreground = p.accent5,
          }
          cs.notificationsWarningIcon = {
            foreground = p.accent2,
          }

          cs.base = {
            dark = p.dark2, -- "#19181a"
            black = p.dark1, --"#221f22",
            red = p.accent1, -- "#ff6188",
            green = p.accent4, -- "#a9dc76",
            yellow = p.accent3, -- "#ffd866",
            blue = p.accent2, -- "#fc9867",
            magenta = p.accent6, -- "#ab9df2",
            cyan = p.accent5, -- "#78dce8",
            white = p.text, -- "#fcfcfa",
            dimmed1 = p.dimmed1, -- "#c1c0c0",
            dimmed2 = p.dimmed2, -- "#939293",
            dimmed3 = p.dimmed3, -- "#727072",
            dimmed4 = p.dimmed4, -- "#5b595c",
            dimmed5 = p.dimmed5, -- "#403e41",
          }
          return cs
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
            CursorLineNr = {
              bold = false,
            }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
            FoldColumn = {
              bg = c.editor.statuscolBackground,
            }, -- 'foldcolumn'
            SignColumn = {
              bg = c.editor.statuscolBackground,
            },
            LineNr = {
              bg = c.editor.statuscolBackground,
            }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
            MatchParen = {
              bold = false,
            }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            SignColumn = {
              bold = false,
            }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            PmenuSbar = {
              bold = false,
            }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
            FloatTitle = { bold = false },
            PmenuSel = { bold = false },
            IncSearch = { bold = false },
            Title = { bold = false },
            CmpItemAbbrMatch = { bold = false }, -- text match in order
            CmpItemAbbrDeprecated = { strikethrough = false }, -- text not match of deprecated
            BufferLineErrorDiagnosticSelected = { bold = false },
            BufferLineErrorDiagnostic = { bold = false },
            BufferLineErrorDiagnosticVisible = { bold = false },
            BufferLineInfoDiagnosticSelected = { bold = false },
            BufferLineInfoDiagnostic = { bold = false },
            BufferLineInfoDiagnosticVisible = { bold = false },
            LazyH1 = { bold = false },
            LazyH2 = { bold = false },
            LazyButtonActive = { bold = false },
            LazySpecial = { bold = false },
            MasonHeaderSecondary = { bold = false },
            MasonHighlightBlockBoldSecondary = { bold = false },
            MasonMutedBlockBold = { bold = false },
            NeoTreeCursorLine = { bold = false },
            NeoTreeRootName = { bold = false },
            NeoTreeTitleBar = { bold = false },
            NeoTreeFloatTitle = { bold = false },
            NeoTreeTabActive = { bold = false },
            NoiceFormatProgressDone = { bold = false },
            NoiceFormatProgressTodo = { bold = false },
            NvimTreeOpenedFolderName = { bold = false },
            NvimTreeEmptyFolderName = { bold = false },
            NvimTreeRootFolder = { bold = false },
            ["@punctuation.delimiter"] = { fg = c.base.white },
            ["@punctuation.bracket"] = { fg = c.base.white }, -- `(`
            ["@tag.delimiter"] = { fg = c.base.white }, -- `<`, `>` in `<div>`
            ["@parameters"] = { fg = c.base.cyan, italic = false },
            ["@property"] = { fg = c.base.green },
            ["@function"] = { fg = c.base.blue },
            ["@function.attribute"] = { fg = c.base.green },
            ["@keyword.function"] = { fg = c.base.red, bold = false, italic = false },
            ["@string.scss"] = { fg = c.base.blue, italic = false },
            ["@keyword.cpp"] = { fg = c.base.red, italic = false },
            ["@type.cpp"] = { fg = c.base.cyan, italic = false },
            ["@punctuation.delimiter.cpp"] = { fg = c.base.white },
            ["@type.python"] = { fg = c.base.blue },
            ["@keyword.python"] = { fg = c.base.red, italic = false },
            ["@variable.builtin.python"] = { fg = c.base.cyan, italic = false, },
            ["@variable.python"] = { fg = c.base.white },
            ["@constructor.python"] = { fg = c.base.blue },
            ["@method.python"] = { fg = c.base.blue },
            ["@function.builtin.python"] = { fg = c.base.cyan, italic = false },
            ["@exception.python"] = { fg = c.base.red, italic = false },
            ["@keyword.function.python"] = { fg = c.base.red, italic = false },
            ["@variable.builtin.python"] = { fg = c.base.cyan, italic = false },
            ["@parameters.python"] = { fg = c.base.cyan, italic = false },
            ["@function.builtin.lua"] = { fg = c.base.cyan },
            ["@parameter.lua"] = { fg = c.base.blue, italic = false },
            ["@text.environment.name.latex"] = { fg = c.base.blue, italic = false },
            ["@text.strong.latex"] = { bold = false },
            ["@text.emphasis.latex"] = { italic = false },
            ["@text.strong.markdown_inline"] = { fg = c.base.white, bold = false },
            ["@text.emphasis.markdown_inline"] = { fg = c.base.white, italic = false },
            RenamerTitle = { bold = false },
            TelescopeSelection = { bold = false },
            TelescopeSelectionCaret = { bold = false },
            TelescopePromptCounter = { bold = false },
            TelescopeMatching = { bold = false },
            TelescopePromptTitle = { bold = false },
            TelescopePreviewTitle = { bold = false },
            TelescopeResultsTitle = { bold = false },
            WildMenu = { bold = false },
            Bold = { bold = false },
            Italic = { italic = false },
            Todo = { bold = false },
          }
        end,
      })
      vim.cmd([[colorscheme monokai-pro]])
      -- vim.cmd([[colorscheme midnightokai]])
    end,
  -- },{
  --   "tjdevries/colorbuddy.nvim",
  --   priority = 2002,
  --   lazy = false,
  -- },{
  --   "Red_M/midnightokai",
  --   dev = true,
  --   enabled = true,
  --   lazy = false,
  --   priority = 2001,
  --   dependencies = {
  --     "tjdevries/colorbuddy.nvim",
  --   },
  --   config = function(opts)
  --     require('midnightokai').setup(opts)
  --     vim.cmd([[colorscheme midnightokai]])
  --   end,
  },
}

