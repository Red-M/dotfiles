local _sf = string.format
local _mf = math.floor
local _printf = function(...) print(_sf(...)) end

local scite_luarocks = require 'scite_luarocks'


local sysdetect = scite_luarocks.install_and_require('sysdetect','rocks-sysdetect')
local os_response = not(sysdetect.detect() == 'windows') -- Assume we're on an intelligent planet if true
--~ _printf(sysdetect.detect()))
local packages_lookup = {}
packages_lookup[true] = {
    yaml = { 'lyaml' },
    json = { 'lunajson' },
    lfs = { 'lfs','luafilesystem' },
}
packages_lookup[false] = {
    yaml = { 'yaml', 'lua-yaml' },
    json = { 'lunajson' },
    lfs = { 'lfs','luafilesystem' },
}

local yaml = scite_luarocks.install_and_require(table.unpack(packages_lookup[os_response]['yaml']))
local json = scite_luarocks.install_and_require(table.unpack(packages_lookup[os_response]['json']))
local lfs = scite_luarocks.install_and_require(table.unpack(packages_lookup[os_response]['lfs']))


--~ if os_response == true then
--~     yaml = scite_luarocks.install_and_require('lyaml')
--~     json = scite_luarocks.install_and_require('lunajson')
--~     local lfs = scite_luarocks.install_and_require('lfs','luafilesystem')
--~ else
--~     yaml = scite_luarocks.install_and_require('yaml','lua-yaml')
--~     json = scite_luarocks.install_and_require('lunajson')
--~ end


local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

local split = function(s)
    local args = {}
    for a in string.gmatch(s, "%S+") do
       table.insert(args, a)
    end
    return args
end

local clamp = function(x, min, max)
    if x > max then return max end
    if x < min then return min end
    return x
end

-- from a (m=0) to b (m=1) ; a, b in [0, 1]
local mix = function(m, a, b)
    if m == 0 then return a end
    if m == 1 then return b end
    return clamp((1 - m) * a + m * b, 0, 1)
end

local adjmix = function(m, x, min, max)
    if m > 1 then return mix(m - 1, x, max) end
    return mix(m, min, x)
end

-- from 0 (m=0) to a (m=1) to 1 (m=2); a in [0, 1]
local adj = function(m, a)
    if m == 1 then return a end
    m = clamp(m, 0, 2)
    if m < 1 then
        return m * a
    else
        return (2 - m) * a + (m - 1)
    end
end

-- r, g, b in [0, 255]
local to_hsl = function(r, g, b)
    --r, g, b = clamp(r, 0, 255), clamp(g, 0, 255), clamp(b, 0, 255)
    r, g, b = r / 0xFF, g / 0xFF, b / 0xFF
    local max, min = math.max(r, g, b), math.min(r, g, b)
    if max == min then return 0, 0, min end

    local l, d = max + min, max - min
    local s, h = d / (l > 1 and (2 - l) or l)
    l = l / 2
    if max == r then
        h = (g - b) / d
        if g < b then h = h + 6 end
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    return h, s, l
end

local FF = function(a) return _mf(a * 0xFF) end

-- h in [0, 6], s in [0, 1], l in [0,1]
local to_rgb = function(h, s, l)
    --h, s, l = h % 6, clamp(s, 0, 1), clamp(l, 0, 1)
    if s == 0 then l = FF(l) return l,l,l end

    local c, m
    if l > 0.5 then c = (2 - 2 * l) * s
    else c = (2 * l) * s end
    m = l - c / 2

    local r, g, b
    if     h < 1 then b, r, g = 0, c, c * h
    elseif h < 2 then b, g, r = 0, c, c * (2 - h)
    elseif h < 3 then r, g, b = 0, c, c * (h - 2)
    elseif h < 4 then r, b, g = 0, c, c * (4 - h)
    elseif h < 5 then g, b, r = 0, c, c * (h - 4)
    else              g, r, b = 0, c, c * (6 - h)
    end
    return FF(r + m), FF(g + m), FF(b + m)
end

local rgbstr_to_hsl = function(s)
    local r, g, b = string.match(s, '#?(%x%x)(%x%x)(%x%x)')
    if r == nil then return end
    return to_hsl(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

local hsl_to_rgbstr = function(h, s, l)
    return _sf('#%02x%02x%02x', to_rgb(h, s, l))
end

function find_theme_files(path,files)
    if files == nil then
        files = {}
    end
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            local attr = lfs.attributes(f)
            if type(attr) == "table" then
                if attr.mode == "directory" then
                    find_theme_files(f,files)
                elseif ends_with(file, '.json') or ends_with(file, '.yaml') then
                    table.insert(files, f)
                end
            end
        end
    end
    return files
end

local remapper = {}

remapper['.yaml'] = {
    entry = '^%s*([%w]+)%s*:%s*"([^"]-)"',
--~ 	loader = yaml.eval,
    loader = yaml.load,
    map = {
        scheme = 'name',
        author = 'author',
        base00 = 'back',
        base01 = 'lnback',
        base02 = 'whitespace',
        base03 = 'comment',
        base04 = 'lnfore',
        base05 = 'fore',
        base06 = 'operator',
        base07 = 'highlight',
        base08 = 'variable',
        base09 = 'number',
        base0A = 'class',
        base0B = 'string',
        base0C = 'support',
        base0D = 'function',
        base0E = 'keyword',
        base0F = 'embed',
    },
}

remapper['.json'] = {
    entry = '^%s*"([%w_]+)"%s*:%s*"#?([^"]-)"',
    loader = json.decode,
    map = {
        name = 'name',
        author = 'author',
        background = 'back',
        line_highlight = 'lnback',
        invisibles = 'whitespace',
        comment = 'comment',
        docblock = 'lnfore',
        foreground = 'fore',
        caret = 'operator',
        selection_foreground = 'highlight',
        fifth = 'variable',
        number = 'number',
        second = 'class',
        ['string'] = 'string',
        first = 'support',
        third = 'function',
        fourth = 'keyword',
        brackets = 'embed',
    },
}

local parse_scheme = function(path, ext)
    if remapper[ext] == nil then return end;
    local map, loader, entry = remapper[ext].map, remapper[ext].loader, remapper[ext].entry
    local vars = {}
    local key, value
    local h, s, l

    local f = io.open(path,'r')
    local data = loader(f:read("*all"))
    f:close()
    if data['theme'] ~= nil then -- merge down the theme subkey on the current JSON files
        for k,v in pairs(data['theme']) do data[k] = v end
    end

    for key, value in pairs(data) do
        key = key and map[key]
        if key ~= nil then
            h, s, l = rgbstr_to_hsl(value)
            if h ~= nil then  vars[key] = {h, s, l}
            else vars[key] = value end
        end
    end
    for id, k in pairs(map) do
        if vars[k] == nil then
        _printf('missing value %s in %s', id, path) return end
    end
    return vars
end

-- adjust all colors
local adjust_colors = function(t, sm, lm)
    local h, s, l
    for k, v in pairs(t) do
        if type(v) == 'table' then
            v[2] = adj(sm, v[2])
            v[3] = adj(lm, v[3])
        end
    end
end


local isfile = function(fname)
    local f = io.open(fname, 'r')
    if f then io.close(f) return true end
    return false
end

local locate_scheme = function(pdir, name)
    --pdir = pdir .. '/'
    if isfile(pdir .. name) then return name end


    local s
    local search = {
        _sf('%s.yaml', name),
        _sf('%s.json', name)
    }
    for i, s in ipairs(search) do
        if isfile(pdir .. s) then return s end
    end
    local f = io.open(props['ext.lua.theme_dir']..'/scheme_list.yaml','r')
    local list = yaml.load(f:read('*all'))
    f:close()
    for i, scheme_file in ipairs(list) do
        for ii, s in ipairs(search) do
            if ends_with(scheme_file, s) then
                if isfile(pdir .. scheme_file) then return scheme_file end
            end
        end
    end
end

OnOpenEvents = {} -- push to this if you need to use onopen
OnOpen = function(...)
    for i, e in ipairs(OnOpenEvents) do e(...) end
end

local CallTipHlt
local function setCallTipHlt()
    editor.CallTipForeHlt = CallTipHlt
end

local function setCallTipHlt_OnOpen(...)
    setCallTipHlt(CallTipHlt)
    for i = #OnOpenEvents, 1 do
        if OnOpenEvents[i] == setCallTipHlt_OnOpen then
            table.remove(OnOpenEvents, i)
        end
    end
end

local function setCallTipHighlight(hsl)
    local r, g, b = to_rgb(hsl[1], hsl[2], hsl[3])
    CallTipHlt = r + 0x100 * g + 0x10000 * b
    if pcall(setCallTipHlt) then -- this may fail if there is no pane
        return
    end
    for i, f in ipairs(OnOpenEvents) do
        if f == setCallTipHlt_OnOpen then return end
    end
    table.insert(OnOpenEvents, 1, setCallTipHlt_OnOpen)
end

local function writeThemeSwitch(switch_prop,theme_prop)
    f_theme_props = io.open(switch_prop, 'w')
    f_theme_props:write('import '..theme_prop..'\n')
    f_theme_props:close()
end

local apply_scheme = function(name)
    local requested_name = name
    local disable_theme_translation = props['ext.lua.theme_disable_theme_translation']=='1'
    local generate_theme_translations = props['ext.lua.theme_generate_theme_translations']=='1'
    local theme_dir = props['ext.lua.theme_dir']
    local schemes_dir = theme_dir .. '/schemes/'
    local props_dir = theme_dir .. '/props/'
    local generated_props_dir = props_dir .. 'generated/'
    local generated_props_path = generated_props_dir..string.gsub(requested_name,"^.*%/(.*)%..*$",'%1')

    if disable_theme_translation == true then
        writeThemeSwitch(theme_dir..'/theming.properties',generated_props_path)
        for line in io.lines(generated_props_path..'.properties') do
            if (line:match('%S') ~= nil) and (line:match('^%s*#') == nil) then
                key, value = string.match(line, '^%s*([%w_.%-*]+)%s*=%s*(.-)%s*$')
                if key then
                    props[key] = value
                end
            end
        end
        -- scite.ReloadProperties()
        -- setCallTipHighlight(vars["variable"])
        props['ext.lua.theme_now'] = name
        return
    end

    local sdim = tonumber(props['ext.lua.theme_sdim']) or 0.5
    local ldim = tonumber(props['ext.lua.theme_ldim']) or 0.5
    local sbright = tonumber(props['ext.lua.theme_sbright']) or 1.5
    local lbright = tonumber(props['ext.lua.theme_lbright']) or 1.5
    local sadj = tonumber(props['ext.lua.theme_sadj']) or 1.0
    local ladj = tonumber(props['ext.lua.theme_ladj']) or 1.0
    local wsadj = tonumber(props['ext.lua.theme_wsadj']) or 0.5

    local scheme_path = locate_scheme(schemes_dir, name)
    if not scheme_path then
        _printf('File "%s" cannot be found', name)
        return
    end

    name = scheme_path
    scheme_path = schemes_dir .. scheme_path

    local vars
    local filetype = scheme_path:sub(-5)
    vars = parse_scheme(scheme_path, filetype)
    if vars == nil then
        _printf('Filetype "%s" is not supported', filetype)
        return
    end

    adjust_colors(vars, sadj, ladj)
    local ws = vars.whitespace
    vars.whitespace = {ws[1], ws[2], adjmix(wsadj, ws[3], vars.back[3], vars.fore[3])}

    local curline_no = 0
    local curline = ''
    local curfile = ''
    local template_path

    local replacefn = function(k)
        local vk = vars[k]
        if vk ~= nil then
            return hsl_to_rgbstr(vk[1], vk[2], vk[3])
        end

        local args = split(k)

        if args[1] == 'dim' and #args == 2 then
            vk = vars[args[2]]
            if vk ~= nil then
                vk = {vk[1], adj(sdim, vk[2]), adjmix(ldim, vk[3], vars.back[3], vars.fore[3])}
                vars[args[2]..'-dim'] = vk
                return hsl_to_rgbstr(vk[1], vk[2], vk[3])
            end
        end
        if args[1] == 'bright' and #args == 2 then
            vk = vars[args[2]]
            if vk ~= nil then
                vk = {vk[1], adj(sbright, vk[2]), adjmix(lbright, vk[3], vars.back[3], vars.fore[3])}
                vars[args[2]..'-bright'] = vk
                return hsl_to_rgbstr(vk[1], vk[2], vk[3])
            end
        end
        _printf('.. %s:%i: "%s" (cannot substitute)', curfile, curline_no, k)
    end

    local key, value
    local configured_theme = props['ext.lua.theme']:lower():gsub(' ','-'):gsub('[,]','')
    local write_theme_file = requested_name == configured_theme or generate_theme_translations == true
    local props_list = dofile(theme_dir .. '/prop_list.lua')
    local f = ''
    if write_theme_file == true then
        f = io.open(generated_props_path..'.properties', 'w')
    end
    for i, v in ipairs(props_list) do
        curfile = v
        curline_no = 0
        template_path = props_dir .. v
        for line in io.lines(template_path) do
            curline = line
            curline_no = curline_no + 1
            if (line:match('%S') ~= nil) and (line:match('^%s*#') == nil) then
                key, value = string.match(line, '^%s*([%w_.%-*]+)%s*=%s*(.-)%s*$')
                if key then
                    props[key] = value:gsub('$%(colou?r%s+([%w%p ]+)%)', replacefn)
                    if write_theme_file == true then
                        f:write(key.."="..props[key].."\n")
                    end
                    --_printf('Setting %s: %s -> %s', template_path, key, props[key])
                else
                    if write_theme_file == true then
                        f:write(line.."\n")
                    end
                    --_printf('.. %s:%i: "%s" (cannot parse)', curfile, curline_no, curline)
                end
            else
                if write_theme_file == true then
                    f:write(line.."\n")
                end
            end
        end
    end
    if write_theme_file == true then
        f:write('\n')
        f:close()
        writeThemeSwitch(theme_dir..'/theming.properties',generated_props_path)
    end

    setCallTipHighlight(vars["variable"])
    --_printf('Using theme "%s" by "%s"', vars['name'], vars['author'])
    props['ext.lua.theme_now'] = name
end

-- Change to the fixed theme defined in user properties file
function change_theme()
    local name = props['ext.lua.theme']:lower():gsub(' ','-'):gsub('[,]','')
    apply_scheme(name)
    --_printf('Using "%s"', props['ext.lua.theme_now'])
end

-- Change to the next theme (resets to the fixed one after restart)
function cycle_theme(forward,step)
    local dir = props['ext.lua.theme_dir']
    local name = props['ext.lua.theme_now']
    local print_theme_name = props['ext.lua.theme_print_theme_name']=='1'
    local f = io.open(dir..'/scheme_list.yaml','r')
    local list = yaml.load(f:read('*all'))
    f:close()
    local list_len = #list
    local list_cur = 0
    for i, v in ipairs(list) do
        if v == name then
            list_cur = i
            break
        end
    end
    if list_cur == 0 then
        list_cur = 1
    end
    local dir_step = step
    if forward==false then
        dir_step = -1 * dir_step
    end
    list_cur = 1 + ((list_cur + dir_step - 1) % list_len)
    name = list[list_cur]
    if props['ext.lua.theme_disable_light']=='1' then
        if string.find(name, "light") then
            cycle_theme(forward,step+1)
            return
        end
    end
    apply_scheme(name)
    if print_theme_name == true then
        _printf('Using "%s" %i/%i', props['ext.lua.theme_now'], list_cur, list_len)
    end
end

function next_theme()
    cycle_theme(true,1)
end

function prev_theme()
    cycle_theme(false,1)
end

function load_themes()
    local theme_dir = props['ext.lua.theme_dir']
    local gen_scheme_list_lua = function()
        local theme_files = find_theme_files(theme_dir..'/schemes')
        local themes = {}
        for i,filename in pairs(theme_files) do
            filename,_ = filename:gsub("^" .. theme_dir .. "/schemes/", "")
            table.insert(themes, filename)
        end
        table.sort(themes)
        local f = io.open(theme_dir..'/scheme_list.yaml', 'w')
        f:write(yaml.dump({themes}))
        f:close()
    end
    if os_response == true then
        gen_scheme_list_lua()
    end
    change_theme()
end

if props then
    change_theme()
end

