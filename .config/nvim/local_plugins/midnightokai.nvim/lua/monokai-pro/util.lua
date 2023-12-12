local hp = require("monokai-pro.color_helper")
local nui_ok, _ = pcall(require, "nui.menu")

local M = {}

local function getRealColor(hex_color, base)
  if hex_color == nil or string.len(hex_color) ~= 9 then
    return hex_color
  end

  local filter = require("monokai-pro.colorscheme").filter
  ---@module "monokai-pro.colorscheme.palette.pro"
  local c = require("monokai-pro.colorscheme.palette." .. filter)
  if base == nil then
    base = c.background
  end
  if string.len(base) == 9 then
    base = hp.extend_hex(base, c.background)
  end
  return hp.extend_hex(hex_color, base)
end

local genHlValue = function(hlValue)
  local bg_value = getRealColor(hlValue.bg, hlValue.bg_base)
  local fg_value = getRealColor(hlValue.fg, hlValue.fg_base)
  local sp_value = getRealColor(hlValue.sp, bg_value)
  hlValue.bg = bg_value
  hlValue.fg = fg_value
  hlValue.sp = sp_value
  hlValue.bg_base = nil
  hlValue.fg_base = nil
  hlValue.style = nil
  return hlValue
end

local highlight = function(group, hlValue)
  local link = hlValue.link
  if link ~= nil then
    local cmd = "hi! link " .. group .. " " .. link
    vim.api.nvim_command(cmd)
    return
  end
  local generatedHlValue = genHlValue(hlValue)
  vim.api.nvim_set_hl(0, group, generatedHlValue)
end

M.create_menu = function(title, items, handler)
  if not nui_ok then
    return
  end

  local Menu = require("nui.menu")
  local NuiText = require("nui.text")
  local menuItems = {
    Menu.separator("", {
      char = "-",
      text_align = "right",
    }),
  }
  for _, it in ipairs(items) do
    table.insert(menuItems, Menu.item("   " .. it, { value = it }))
  end
  local popup_border_text = NuiText(" " .. title .. " ", "SPTitle")
  local menu = Menu({
    position = "50%",
    size = {
      width = 25,
      height = #items + 1,
    },
    relative = "editor",
    border = {
      style = {
        "█",
        "█",
        "█",
        "█",
        "▀",
        "▀",
        "▀",
        "█",
      },
      text = {
        top = popup_border_text,
        top_align = "center",
        text_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:SPNormalFloat,FloatBorder:SPFloatBorder,CursorLine:SPCursorLine",
    },
  }, {
    lines = menuItems,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_submit = handler,
  })
  return menu
end

local draw = function(groups)
  if groups == nil then
    return
  end
  for group, value in pairs(groups) do
    highlight(group, value)
  end
end

M.notify = function(msg, level, opts)
  opts = opts or {}
  level = vim.log.levels[level:upper()]
  if type(msg) == "table" then
    msg = table.concat(msg, "\n")
  end
  local nopts = { title = "Monokai-pro" }
  if opts.once then
    return vim.schedule(function()
      vim.notify_once(msg, level, nopts)
    end)
  end
  vim.schedule(function()
    vim.notify(msg, level, nopts)
  end)
end

---@param colors Colorscheme
M.terminal = function(colors)
  -- dark
  vim.g.terminal_color_0 = colors.base.black
  vim.g.terminal_color_8 = colors.base.dimmed3

  -- light
  vim.g.terminal_color_7 = colors.base.white
  vim.g.terminal_color_15 = colors.base.white

  -- colors
  vim.g.terminal_color_1 = colors.base.red
  vim.g.terminal_color_9 = colors.base.red

  vim.g.terminal_color_2 = colors.base.green
  vim.g.terminal_color_10 = colors.base.green

  vim.g.terminal_color_3 = colors.base.yellow
  vim.g.terminal_color_11 = colors.base.yellow

  vim.g.terminal_color_4 = colors.base.blue
  vim.g.terminal_color_12 = colors.base.blue

  vim.g.terminal_color_5 = colors.base.magenta
  vim.g.terminal_color_13 = colors.base.magenta

  vim.g.terminal_color_6 = colors.base.cyan
  vim.g.terminal_color_14 = colors.base.cyan
end

M.is_daytime = function()
  local current_time = os.time()
  local current_hour = tonumber(os.date("%H", current_time))
  return current_hour >= 6 and current_hour < 18
end

---@param hl_groups HlGroups
M.load = function(hl_groups)
  if vim.g.colors_name then
    vim.cmd([[hi clear]])
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "monokai-pro"

  draw(hl_groups)

  local bufferline_icon_group = require("monokai-pro.theme.plugins.bufferline").setup_bufferline_icon()
  draw(bufferline_icon_group)
  -- draw bufferline icons
  vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "BufWinEnter", "BufRead" }, {
    pattern = "*",
    callback = function()
      if vim.g.colors_name ~= "monokai-pro" then
        return true
      end
      bufferline_icon_group = require("monokai-pro.theme.plugins.bufferline").setup_bufferline_icon()
      draw(bufferline_icon_group)
    end,
  })
end

return M
