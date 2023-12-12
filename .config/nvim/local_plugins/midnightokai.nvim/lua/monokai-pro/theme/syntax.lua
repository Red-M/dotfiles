local M = {}

--- @param c Colorscheme The color palette
--- @param config Config
M.setup = function(c, config, _)
  local styles = config.styles
  return {
    Comment = { fg = c.base.dimmed3, italic = styles.comment.italic }, -- Comments
    Constant = { fg = c.base.magenta }, -- (preferred) any constant
    String = { fg = c.base.yellow }, --   a string constant: "this is a string"
    Character = { fg = c.base.magenta }, -- a character constant: 'c', '\n'
    Number = { fg = c.base.magenta }, -- a number constant: 234, 0xff
    Boolean = { fg = c.base.magenta }, -- a boolean constant: TRUE, false
    Float = { fg = c.base.magenta }, -- a floating point constant: 2.3e10
    Identifier = { fg = c.base.white }, -- (preferred) any variable name
    Function = { fg = c.base.green }, -- function name (also: methods for classes)
    Statement = { fg = c.base.magenta }, -- (preferred) any statement
    Conditional = { fg = c.base.red }, --  if, then, else, endif, switch, etc
    Repeat = { fg = c.base.red }, -- for, do, while, etc
    Label = { fg = c.base.red }, -- case, default, etc
    Operator = { fg = c.base.red }, -- "sizeof", "+", "*", etc
    Keyword = { fg = c.base.red, italic = styles.keyword.italic }, -- any other keyword
    Exception = { fg = c.base.red }, -- try, catch, throw
    PreProc = { fg = c.base.yellow }, -- (preferred) generic Preprocessor
    Include = { fg = c.base.red }, -- preprocessor #include
    Define = { fg = c.base.red }, -- preprocessor #define
    Macro = { fg = c.base.red }, -- same as Define
    PreCondit = { fg = c.base.red }, -- preprocessor #if, #else, #endif, etc
    Type = { fg = c.base.white }, -- React, ReactDOM (import React from 'react';)
    StorageClass = { fg = c.base.red, italic = styles.type.italic }, -- static, register, volatile, etc
    Structure = { fg = c.base.cyan, italic = styles.type.italic }, -- struct, union, enum, etc
    Typedef = { fg = c.base.red }, -- A typedef
    Special = { fg = c.base.blue }, -- (preferred) any special symbol
    SpecialChar = { fg = c.base.blue }, -- special character in a constant
    -- Tag = {}, -- you can use CTRL-] on this
    Delimiter = { fg = c.base.white }, -- character that needs attention
    SpecialComment = { fg = c.base.dimmed3 }, -- special things inside a comment
    -- Debug = {}, -- debugging statements
    Underlined = { underline = true }, -- (preferred) text that stands out, HTML links
    Bold = { bold = false },
    -- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|
    Italic = { italic = false },
    Error = { fg = c.inputValidation.errorForeground }, -- (preferred) any erroneous construct
    Todo = {
      bg = c.editor.background,
      fg = c.base.magenta,
      bold = false,
    }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    javaAnnotation = { fg = c.base.dimmed2 },
  }
end

return M
