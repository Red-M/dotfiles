
local hp = require('.color_helper')

local M = {
  Color = require('colorbuddy.init').Color,
  colors = require('colorbuddy.init').colors,
  Group = require('colorbuddy.init').Group,
  groups = require('colorbuddy.init').groups,
  styles = require('colorbuddy.init').styles,
}

function M.setup(opts)
  if not opts then
    opts = {}
  end

  -- for k, v in pairs(defaults) do
  --   if opts[k] == nil then
  --     opts[k] = v
  --   end
  -- end


  if vim.g.colors_name then
    vim.cmd('hi clear')
  end

  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'midnightokai'

  local Color, colors, Group, groups, styles = require('colorbuddy').setup()

  Color.new('c_dark2','#272822')
  Color.new('c_dark1','#383830')
  Color.new('c_bg','#272822')
  Color.new('c_text','#f5f4f1')
  Color.new('c_magenta','#f92672') --accent1
  Color.new('c_orange','#fd971f') -- accent2
  Color.new('c_yellow','#e6db74') -- accent3
  Color.new('c_green','#a6e22e') -- accent4
  Color.new('c_azure','#9effff') -- accent5
  Color.new('c_purple','#ae81ff') -- accent6
  Color.new('c_dimmed1','#c0c1b5')
  Color.new('c_dimmed2','#919288')
  Color.new('c_dimmed3','#6e7066')
  Color.new('c_dimmed4','#57584f')
  Color.new('c_dimmed5','#3b3c35')
  Color.new('c_lineHighlightBackground', hp.blend(colors.c_orange, 0.15, colors.c_bg))
  Color.new('c_selectionBackground', hp.blend(colors.c_dimmed1, 0.35, colors.c_bg))
  Color.new('c_foldBackground', hp.blend(colors.c_text, 0.35, colors.c_bg))
  Color.new('c_statuscolBackground', hp.blend(colors.c_dimmed5, 0.75, colors.c_bg))
  Color.new('c_editorLineNumber_foreground', hp.blend(colors.c_dimmed1, 0.75, colors.c_dimmed2))
  Color.new('c_editorLineNumber_activeForeground', hp.blend(colors.c_text, 0.95, colors.c_dimmed1))
  Color.new('c_insertedLineBackground', hp.blend(colors.c_green, 0.1, colors.c_dark1))
  Color.new('c_insertedForeground', hp.blend(colors.c_green, 0.65, colors.c_insertedLineBackground))

  local bg_color = colors.c_bg
  -- Use Color.new(<name>, <#rrggbb>) to create new colors
  -- They can be accessed through colors.c_<name>

  Group.new('Normal', colors.c_text, bg_color)
  Group.new('NormalFloat', colors.c_text, bg_color)
  Group.new('NormalNC', colors.c_text, bg_color)
  -- Define highlights in terms of `colors.c_ and `groups`
  -- Group.new('Function'        , colors.c_yellow      , colors.c_bg , styles.bold)
  -- Group.new('luaFunctionCall' , groups.Function    , groups.Function   , groups.Function)

  -- Define highlights in relative terms of other colors
  -- Group.new('Error'           , colors.red:light() , nil               , styles.bold)

  -- Color.new('c_base03', '#002b36')
  -- Color.new('c_base02', '#073642')
  -- Color.new('c_base01', '#586e75')
  -- Color.new('c_base00', '#657b83')
  -- Color.new('c_base0', '#839496')
  -- Color.new('c_base1', '#93a1a1')
  -- Color.new('c_base2', '#eee8d5')
  -- Color.new('c_base3', '#fdf6e3')
  -- Color.new('yellow', '#b58900')
  Color.new('orange', '#cb4b16')
  Color.new('red', '#d40000')
  -- Color.new('magenta', '#d33682')
  -- Color.new('c_violet', '#6c71c4')
  Color.new('c_blue', '#268bd2')
  -- Color.new('c_cyan', '#2aa198')
  -- Color.new('green', '#719e07')

  Group.new('Error', colors.red)
  Group.new('Warning', colors.c_orange)
  Group.new('Information', colors.blue)
  Group.new('Hint', colors.c_azure)


  Group.new('Comment', colors.c_dimmed3, colors.none)
  Group.new('Constant', colors.c_purple)
  Group.new('Identifier', colors.c_text)

  -- any statement, conditional, repeat (for, do while), label, operator
  Group.new('Statement', colors.c_magenta)
  Group.new('PreProc', colors.red)
  Group.new('Type', colors.c_yellow)
  Group.new('Special', colors.c_text)
  Group.new('SpecialKey', colors.c_text)
  -- Group.new('Underlined', colors.c_violet)
  Group.new('Strikethrough', colors.c_text, colors.none)
  Group.new('Ignore', colors.none)
  Group.new('Error', colors.red)
  Group.new('Todo', colors.c_magenta, colors.none)
  Group.new('Function', colors.c_orange)
  Group.link('Include', groups.PreProc)
  Group.link('Macro', groups.PreProc)
  Group.link('Keyword', groups.Statement)
  Group.link('Delimiter', groups.Special)
  Group.link('Repeat', groups.Statement)
  Group.link('Conditional', groups.Statement)
  Group.link('Define', groups.PreProc)
  Group.new('Operator', colors.c_text)
  Group.link('Character', groups.Constant)
  Group.link('Float', groups.Constant)
  Group.link('Boolean', groups.Constant)
  Group.link('Number', groups.Constant)
  Group.link('Debug', groups.Special)
  Group.link('Label', groups.Statement)
  Group.link('Exception', groups.Statement)
  Group.link('Typedef', groups.Type)
  Group.link('StorageClass', groups.Type)

  Group.link('SpecialChar', groups.Special)
  -- Group.new('SpecialKey', colors.c_base00, colors.c_base02)
  Group.new('Text', colors.c_yellow)
  Group.link('String', groups.Text)
  Group.new('NonText', colors.c_text, colors.none)
  Group.new('StatusLine', colors.c_dimmed3, colors.c_dark2)
  Group.new('StatusLineNC', colors.c_dimmed1, colors.c_dark2)
  Group.new('Visual', colors.c_text, colors.c_selectionBackground)
  Group.new('Directory', colors.c_dimmed3, colors.c_dark1)
  Group.new('ErrorMsg', colors.red, colors.none, styles.reverse)

  Group.new('IncSearch', colors.c_orange, colors.none, styles.standout)
  Group.new('Search', colors.c_yellow, colors.none, styles.reverse)

  Group.new('MoreMsg', colors.c_yellow, colors.none, styles.NONE)
  Group.link('ModeMsg', groups.Normal)
  -- Group.new('Question', colors.c_cyan, colors.none)
  Group.new('WinSeparator', colors.c_dimmed5, colors.none, styles.NONE)
  Group.link('VertSplit', groups.WinSeparator)
  Group.new('Title', colors.c_orange, colors.none)
  -- Group.new('VisualNOS', colors.none, colors.c_base02, styles.reverse)
  Group.link('VisualNOS', groups.Visual)
  Group.new('WarningMsg', colors.c_orange, colors.none)
  -- Group.new('WildMenu', colors.c_base2, colors.c_base02, styles.reverse)
  Group.new('Folded', colors.c_editorLineNumber_activeForeground, colors.c_foldBackground)
  Group.new('FoldColumn', colors.c_dark1, colors.c_statuscolBackground, styles.NONE)

  Group.new('DiffAdd', colors.c_insertedForeground, colors.c_insertedLineBackground)
  Group.new('DiffChange', colors.c_yellow, colors.c_base02, styles.none, colors.c_yellow)
  Group.new('DiffDelete', colors.red, colors.c_base02)
  Group.new('DiffText', colors.c_blue, colors.c_base02, styles.none, colors.c_blue)

  Group.new('SignColumn', colors.c_base0, colors.none, styles.NONE)
  Group.new('Conceal', colors.c_blue, colors.none, styles.NONE)

  Group.new('SpellBad', colors.none, colors.none, styles.undercurl, colors.red)
  Group.new('SpellCap', colors.none, colors.none, styles.undercurl, colors.c_violet)
  Group.new('SpellRare', colors.none, colors.none, styles.undercurl, colors.c_cyan)
  Group.new('SpellLocal', colors.none, colors.none, styles.undercurl, colors.c_yellow)
  -- These are nice alternatives if you like a little more color
  --Group.new('SpellBad', colors.c_violet, colors.c_bg, styles.undercurl)
  --Group.new('SpellCap', colors.c_violet, colors.c_bg, styles.undercurl)
  --Group.new('SpellLocal', colors.c_yellow, colors.c_bg, styles.undercurl)
  --Group.new('SpellRare', colors.c_cyan, colors.c_bg, styles.undercurl)

  -- pum (popup menu)
  Group.new('Pmenu', groups.Normal, colors.c_base02, styles.none) -- popup menu normal item
  Group.new('PmenuSel', colors.c_base01, colors.c_base2, styles.reverse) -- selected item
  Group.new('PmenuSbar', colors.c_base02, colors.none, styles.reverse)
  Group.new('PmenuThumb', colors.c_base0, colors.none, styles.reverse)

  -- be nice for this float border to be cyan if active
  Group.new('FloatBorder', colors.c_base02)

  Group.new('TabLine', colors.c_base0, colors.c_base02, styles.NONE, colors.c_base0)
  Group.new('TabLineFill', colors.c_base0, colors.c_base02)
  Group.new('TabLineSel', colors.c_yellow, bg_color)
  Group.new('TabLineSeparatorSel', colors.c_cyan, colors.none)

  Group.new('LineNr', colors.c_base01, bg_color, styles.NONE)
  Group.new('CursorLine', colors.none, colors.c_lineHighlightBackground)
  Group.new('CursorLineNr', colors.none, colors.none, styles.NONE, colors.c_base1)
  Group.new('ColorColumn', colors.none, colors.c_base02, styles.NONE)
  Group.new('Cursor', colors.c_base03, colors.c_base0, styles.NONE)
  Group.link('lCursor', groups.Cursor)
  Group.link('TermCursor', groups.Cursor)
  Group.new('TermCursorNC', colors.c_base03, colors.c_base01)

  Group.new('MatchParen', colors.red, colors.c_base01)

  Group.new('GitGutterAdd', colors.c_green)
  Group.new('GitGutterChange', colors.c_yellow)
  Group.new('GitGutterDelete', colors.red)
  Group.new('GitGutterChangeDelete', colors.red)

  Group.new('GitSignsAddLn', colors.c_green)
  Group.new('GitSignsAddNr', colors.c_green)
  Group.new('GitSignsChangeLn', colors.c_yellow)
  Group.new('GitSignsChangeNr', colors.c_yellow)
  Group.new('GitSignsDeleteLn', colors.red)
  Group.new('GitSignsDeleteNr', colors.red)
  Group.link('GitSignsCurrentLineBlame', groups.Comment)

  -- vim highlighting
  Group.link('vimVar', groups.Identifier)
  Group.link('vimFunc', groups.Identifier)
  Group.link('vimUserFunc', groups.Identifier)
  Group.link('helpSpecial', groups.Special)
  Group.link('vimSet', groups.Normal)
  Group.link('vimSetEqual', groups.Normal)
  Group.new('vimCommentString', colors.c_violet)
  Group.new('vimCommand', colors.c_yellow)
  Group.new('vimCmdSep', colors.c_blue, colors.none)
  Group.new('helpExample', colors.c_base1)
  Group.new('helpOption', colors.c_cyan)
  Group.new('helpNote', colors.c_magenta)
  Group.new('helpVim', colors.c_magenta)
  Group.new('helpHyperTextJump', colors.c_blue, colors.none)
  Group.new('helpHyperTextEntry', colors.c_green)
  Group.new('vimIsCommand', colors.c_base00)
  Group.new('vimSynMtchOpt', colors.c_yellow)
  Group.new('vimSynType', colors.c_cyan)
  Group.new('vimHiLink', colors.c_blue)
  Group.new('vimGroup', colors.c_blue, colors.none)

  Group.new('gitcommitSummary', colors.c_green)
  Group.new('gitcommitComment', colors.c_base01, colors.none)
  Group.link('gitcommitUntracked', groups.gitcommitComment)
  Group.link('gitcommitDiscarded', groups.gitcommitComment)
  Group.new('gitcommitSelected', groups.gitcommitComment)
  Group.new('gitcommitUnmerged', colors.c_green, colors.none)
  Group.new('gitcommitOnBranch', colors.c_base01, colors.none)
  Group.new('gitcommitBranch', colors.c_magenta, colors.none)
  Group.link('gitcommitNoBranch', groups.gitcommitBranch)
  Group.new('gitcommitDiscardedType', colors.red)
  Group.new('gitcommitSelectedType', colors.c_green)
  Group.new('gitcommitHeader', colors.c_base01)
  Group.new('gitcommitUntrackedFile', colors.c_cyan)
  Group.new('gitcommitDiscardedFile', colors.red)
  Group.new('gitcommitSelectedFile', colors.c_green)
  Group.new('gitcommitUnmergedFile', colors.c_yellow)
  Group.new('gitcommitFile', colors.c_base0)
  Group.link('gitcommitDiscardedArrow', groups.gitCommitDiscardedFile)
  Group.link('gitcommitSelectedArrow', groups.gitCommitSelectedFile)
  Group.link('gitcommitUnmergedArrow', groups.gitCommitUnmergedFile)

  Group.link('diffAdded', groups.Statement)
  Group.link('diffLine', groups.Identifier)

  Group.new('NeomakeErrorSign', colors.c_orange)
  Group.new('NeomakeWarningSign', colors.c_yellow)
  Group.new('NeomakeMessageSign', colors.c_cyan)
  Group.new('NeomakeNeomakeInfoSign', colors.c_green)

  Group.new('CmpItemKind', colors.c_green)
  Group.new('CmpItemMenu', groups.NormalNC)
  -- Group.new('CmpItemAbbr', colors.c_base0, colors.none, styles.none)
  -- Group.new('CmpItemAbbrMatch', colors.c_base0, colors.none, styles.none)
  Group.new('CmpItemKindText', colors.c_base3, colors.none, styles.none)
  Group.new('CmpItemKindMethod', colors.c_green, colors.none, styles.none)
  Group.new('CmpItemKindFunction', colors.c_blue, colors.none, styles.none)
  Group.new('CmpItemKindConstructor', colors.c_orange, colors.none, styles.none)
  Group.new('CmpItemKindField', colors.c_yellow, colors.none, styles.none)
  Group.new('CmpItemKindVariable', colors.c_orange, colors.none, styles.none)
  Group.new('CmpitemKindClass', colors.c_yellow, colors.none, styles.none)
  Group.new('CmpItemKindInterface', colors.c_yellow, colors.none, styles.none)
  Group.new('CmpItemKindModule', colors.c_green, colors.none, styles.none)
  Group.new('CmpItemKindProperty', colors.c_green, colors.none, styles.none)
  Group.new('CmpItemKindUnit', colors.c_orange, colors.none, styles.none)
  Group.new('CmpItemKindValue', colors.c_cyan, colors.none, styles.none)
  Group.new('CmpItemKindEnum', colors.c_yellow, colors.none, styles.none)
  Group.new('CmpItemKindKeyword', colors.c_green, colors.none, styles.none)
  Group.new('CmpItemKindSnippet', colors.c_magenta, colors.none, styles.none)
  Group.new('CmpItemKindColor', colors.c_magenta, colors.none, styles.none)
  Group.new('CmpItemKindFile', colors.c_violet, colors.none, styles.none)
  Group.new('CmpItemKindReference', colors.c_violet, colors.none, styles.none)
  Group.new('CmpItemKindFolder', colors.c_violet, colors.none, styles.none)
  Group.new('CmpItemKindEnumMember', colors.c_cyan, colors.none, styles.none)
  Group.new('CmpItemKindConstant', colors.c_cyan, colors.none, styles.none)
  Group.new('CmpItemKindStruct', colors.c_yellow, colors.none, styles.none)
  Group.new('CmpItemKindEvent', colors.c_orange, colors.none, styles.none)
  Group.new('CmpItemKindOperator', colors.c_cyan, colors.none, styles.none)
  Group.new('CmpItemKindTypeParameter', colors.c_orange, colors.none, styles.none)

  Group.new('LspSagaCodeActionTitle', colors.c_green)
  Group.new('LspSagaBorderTitle', colors.c_yellow, colors.none)
  Group.new('LspSagaDiagnosticHeader', colors.c_yellow)
  Group.new('ProviderTruncateLine', colors.c_base02)
  Group.new('LspSagaShTruncateLine', groups.ProviderTruncateLine)
  Group.new('LspSagaDocTruncateLine', groups.ProviderTruncateLine)
  Group.new('LspSagaCodeActionTruncateLine', groups.ProviderTruncateLine)
  Group.new('LspSagaHoverBorder', colors.c_cyan)
  Group.new('LspSagaRenameBorder', groups.LspSagaHoverBorder)
  Group.new('LSPSagaDiagnosticBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaSignatureHelpBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaCodeActionBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaLspFinderBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaFloatWinBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaSignatureHelpBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaDefPreviewBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaAutoPreviewBorder', groups.LspSagaHoverBorder)
  Group.new('LspFloatWinBorder', groups.LspSagaHoverBorder)
  Group.new('LspLinesDiagBorder', groups.LspSagaHoverBorder)
  Group.new('LspSagaFinderSelection', colors.c_green, colors.none)
  --Group.new('SagaShadow', colors.c_base02)

  Group.new('TelescopeMatching', colors.c_orange, groups.Special, groups.Special, groups.Special)
  Group.new('TelescopeBorder', colors.c_base01) -- float border not quite dark enough, maybe that needs to change?
  Group.new('TelescopePromptBorder', colors.c_cyan) -- active border lighter for clarity
  Group.new('TelescopeTitle', groups.Normal) -- separate them from the border a little, but not make them pop
  Group.new('TelescopePromptPrefix', groups.Normal) -- default is groups.Identifier
  Group.link('TelescopeSelection', groups.CursorLine)
  Group.new('TelescopeSelectionCaret', colors.c_cyan)

  Group.new('NeogitDiffAddHighlight', colors.c_green, colors.c_base02)
  Group.new('NeogitDiffDeleteHighlight', colors.red, colors.c_base02)
  Group.new('NeogitHunkHeader', groups.Normal, colors.c_base02)
  Group.new('NeogitHunkHeaderHighlight', colors.c_base3, colors.c_base1)
  Group.new('NeogitDiffContextHighlight', colors.c_base2, colors.c_base02)
  Group.new('NeogitCommandText', groups.Normal)
  Group.new('NeogitCommandTimeText', groups.Normal)
  Group.new('NeogitCommandCodeNormal', groups.Normal)
  Group.new('NeogitCommandCodeError', groups.Error)
  Group.new('NeogitNotificationError', groups.Error, colors.none)
  Group.new('NeogitNotificationInfo', groups.Information, colors.none)
  Group.new('NeogitNotificationWarning', groups.Warning, colors.none)

  -- seblj/nvim-tabline
  Group.new('TabLineSeparatorActive', colors.c_cyan)
  Group.link('TabLineModifiedSeparatorActive', groups.TablineSeparatorActive)

  -- kevinhwang91/nvim-bqf
  Group.new('BqfPreviewBorder', colors.c_base01)
  Group.new('BqfSign', colors.c_cyan)

  -- Primeagen/harpoon
  Group.new('HarpoonBorder', colors.c_cyan)
  Group.new('HarpoonWindow', groups.Normal)

  -- nvim-tree/nvim-tree.lua
  Group.new('NvimTreeFolderIcon', colors.c_blue)
  Group.new('NvimTreeRootFolder', colors.c_orange)
  Group.new('NvimTreeImageFile', colors.c_orange)
  Group.new('NvimTreeSpecialFile', colors.c_orange, colors.none)

  -- phaazon/hop.nvim
  Group.link('HopNextKey', groups.IncSearch)
  Group.link('HopNextKey1', groups.IncSearch)
  Group.link('HopNextKey2', groups.IncSearch)

  -- https://github.com/j-hui/fidget.nvim (for some reason the background
  -- is only correct if used with background_set = true) even when set below)
  Group.new('FidgetTitle', colors.c_magenta)
  Group.new('FidgetTask', colors.c_base0)

  -- TreeSitter
  Group.link('TSBoolean', groups.Constant)
  Group.link('TSCharacter', groups.Constant)
  Group.link('TSComment', groups.Comment)
  Group.link('TSConditional', groups.Conditional)
  Group.link('TSConstant', groups.Constant)
  Group.link('TSConstBuiltin', groups.Constant)
  Group.link('TSConstMacro', groups.Constant)
  Group.link('TSError', groups.Error)
  Group.link('TSException', groups.Exception)
  Group.link('TSField', groups.Identifier)
  Group.link('TSFloat', groups.Constant)
  Group.link('TSFunction', groups.Function)
  Group.link('TSFuncBuiltin', groups.Function)
  Group.link('TSFuncMacro', groups.Function)
  Group.link('TSInclude', groups.Include)
  Group.link('TSKeyword', groups.Keyword)
  Group.link('TSLabel', groups.Statement)
  Group.link('TSMethod', groups.Function)
  Group.link('TSNamespace', groups.Identifier)
  Group.link('TSNumber', groups.Constant)
  Group.link('TSOperator', groups.Operator)
  Group.link('TSParameterReference', groups.Identifier)
  Group.link('TSProperty', groups.TSField)
  Group.link('TSPunctDelimiter', groups.Delimiter)
  Group.link('TSPunctBracket', groups.Delimiter)
  Group.link('TSPunctSpecial', groups.Special)
  Group.link('TSRepeat', groups.Repeat)
  Group.link('TSString', groups.Constant)
  Group.link('TSStringRegex', groups.Constant)
  Group.link('TSStringEscape', groups.Constant)
  Group.new('TSStrong', colors.c_base1, colors.none)
  Group.link('TSConstructor', groups.Function)
  Group.link('TSKeywordFunction', groups.Identifier)
  Group.new('TSLiteral', groups.Normal)
  Group.link('TSParameter', groups.Identifier)
  Group.link('TSVariable', groups.Normal)
  Group.link('TSVariableBuiltin', groups.Identifier)
  Group.link('TSTag', groups.Special)
  Group.link('TSTagDelimiter', groups.Delimiter)
  Group.link('TSTitle', groups.Title)
  Group.link('TSType', groups.Type)
  Group.link('TSTypeBuiltin', groups.Type)

  Group.link('DiagnosticError', groups.Error)
  Group.new('DiagnosticWarn', colors.c_yellow)
  Group.new('DiagnosticInfo', colors.c_cyan)
  Group.new('DiagnosticHint', colors.c_green)
  Group.new('DiagnosticUnderlineError', colors.none, colors.none)
  Group.new('DiagnosticUnderlineWarn', colors.none, colors.none)
  Group.new('DiagnosticUnderlineInfo', colors.none, colors.none)
  Group.new('DiagnosticUnderlineHint', colors.none, colors.none)
  Group.link('DiagnosticVirtualTextHint', groups.Comment)
  Group.link('DiagnosticTextWarn', groups.WarningMsg)

  Group.new('LspReferenceRead', colors.none, colors.none)
  Group.link('LspReferenceText', groups.LspReferenceRead)
  Group.new('LspReferenceWrite', colors.none, colors.none)

  -- folke/which-key.nvim
  Group.new('WhichKeySeparator', colors.c_base01, colors.c_base02)
  Group.new('WhichKeyDesc', colors.c_cyan, colors.c_base02)

  -- group names with an ampersand throw an error until they gain support in 0.8.0
  if vim.fn.has('nvim-0.8.0') ~= 0 then
    -- XML-like tags
    Group.new('@tag', colors.c_green)
    Group.new('@tag.attribute', colors.c_blue)
    Group.new('@tag.delimiter', colors.red)

    Group.new('@none', colors.none)
    Group.link('@comment', groups.Comment)
    Group.link('@error', groups.Error)
    Group.link('@preproc', groups.PreProc)
    Group.link('@define', groups.Define)
    Group.link('@operator', groups.Operator)

    Group.link('@punctuation.delimiter', groups.Statement)
    Group.link('@punctuation.bracket', groups.Delimiter)
    Group.link('@punctuation.special', groups.Delimiter)

    Group.link('@string', groups.String)
    Group.link('@string.regex', groups.String)
    Group.link('@string.escape', groups.Special)
    Group.link('@string.special', groups.Special)

    Group.link('@character', groups.Character)
    Group.link('@character.special', groups.Special)

    Group.link('@boolean', groups.Boolean)
    Group.link('@number', groups.Number)
    Group.link('@float', groups.Float)

    Group.link('@function', groups.Function)
    Group.link('@function.call', groups.Function)
    Group.link('@function.builtin', groups.Function)
    Group.link('@function.macro', groups.Macro)

    Group.link('@method', groups.Function)
    Group.link('@method.call', groups.Function)

    Group.link('@constructor', groups.Special)
    -- not sure about this one, special is true and kinda nice?
    Group.link('@parameter', groups.Special)

    Group.link('@keyword', groups.Keyword)
    Group.link('@keyword.function', groups.Keyword)
    Group.link('@keyword.operator', groups.Keyword)
    Group.link('@keyword.return', groups.Keyword)

    Group.link('@conditional', groups.Conditional)
    Group.link('@repeat', groups.Repeat)
    Group.link('@debug', groups.Debug)
    Group.link('@label', groups.Label)
    Group.link('@include', groups.Include)
    Group.link('@exception', groups.Exception)

    Group.link('@type', groups.Type)
    Group.link('@type.builtin', groups.Type)
    Group.link('@type.qualifier', groups.Type)
    Group.link('@type.definition', groups.Typedef)

    Group.link('@storageclass', groups.StorageClass)
    Group.link('@attribute', groups.Identifier)
    Group.link('@field', groups.Identifier)
    Group.link('@property', groups.Identifier)

    Group.new('@variable', colors.c_base0)
    Group.link('@variable.builtin', groups.Special)

    Group.link('@constant', groups.Constant)
    Group.link('@constant.builtin', groups.Type)
    Group.link('@constant.macro', groups.Define)

    Group.link('@namespace', groups.Identifier)
    Group.link('@symbol', groups.Identifier)

    Group.link('@text', groups.Normal)
    Group.new('@text.strong', colors.c_base1, colors.none)
    Group.new('@text.emphasis', colors.c_base1, colors.none)
    -- Group.link('@text.underline', groups.Underlined)
    -- Group.link('@text.strike', groups.Strikethrough)
    Group.link('@text.title', groups.Title)
    Group.link('@text.literal', groups.String)
    -- Group.link('@text.uri', groups.Underlined)
    Group.link('@text.math', groups.Special)
    Group.link('@text.environment', groups.Macro)
    Group.link('@text.environment.name', groups.Type)
    Group.link('@text.reference', groups.Constant)

    Group.link('@text.todo', groups.Todo)
    Group.link('@text.note', groups.Comment)
    Group.link('@text.warning', groups.WarningMsg)
    Group.new('@text.danger', colors.red, colors.none)
  end

  if vim.fn.has('nvim-0.9.0') ~= 0 then
    Group.link('@lsp.type.type', groups.Type)
    Group.link('@lsp.type.class', groups.Type)
    Group.link('@lsp.type.enum', groups.Type)
    Group.link('@lsp.type.interface', groups.Type)
    Group.link('@lsp.type.struct', groups.Type)
    Group.link('@lsp.type.typeParameter', groups.Type)
    Group.link('@lsp.type.parameter', groups.Special)
    Group.link('@lsp.type.variable', groups.TSVariable)
    Group.link('@lsp.type.property', groups.TSProperty)
    Group.link('@lsp.type.enumMember', groups.TSProperty)
    Group.link('@lsp.type.events', groups.Label)
    Group.link('@lsp.type.function', groups.Function)
    Group.link('@lsp.type.method', groups.TSMethod)
    Group.link('@lsp.type.keyword', groups.Keyword)
    Group.link('@lsp.type.modifier', groups.Operator)
    Group.link('@lsp.type.comment', groups.Comment)
    Group.link('@lsp.type.string', groups.String)
    Group.link('@lsp.type.number', groups.Number)
    Group.link('@lsp.type.regexp', groups.TSStringRegex)
    Group.link('@lsp.type.operator', groups.Operator)
  end

  function M.translate(group)
    if vim.fn.has('nvim-0.6.0') == 0 then
      return group
    end

    if not string.match(group, '^LspDiagnostics') then
      return group
    end

    local translated = group
    translated = string.gsub(translated, '^LspDiagnosticsDefault', 'Diagnostic')
    translated = string.gsub(translated, '^LspDiagnostics', 'Diagnostic')
    translated = string.gsub(translated, 'Warning$', 'Warn')
    translated = string.gsub(translated, 'Information$', 'Info')
    return translated
  end

  local lspColors = {
    Error = groups.Error,
    Warning = groups.Warning,
    Information = groups.Information,
    Hint = groups.Hint,
  }
  for _, lsp in pairs({ 'Error', 'Warning', 'Information', 'Hint' }) do
    local lspGroup = Group.new(M.translate('LspDiagnosticsDefault' .. lsp), lspColors[lsp])
    Group.link(M.translate('LspDiagnosticsVirtualText' .. lsp), lspGroup)
    Group.new(
      M.translate('LspDiagnosticsUnderline' .. lsp),
      colors.none,
      colors.none,
      styles.undercurl,
      lspColors[lsp]
    )
  end

  for _, name in pairs({ 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' }) do
    Group.link(M.translate(name), groups.CursorLine)
  end


  return(M)
end


return(M)

