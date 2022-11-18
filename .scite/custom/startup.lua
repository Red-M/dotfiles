local _sf = string.format
local _mf = math.floor
local _printf = function(...) print(_sf(...)) end
package.path = props['custom.scite.extdir'] .. '/pure_lua/?.lua;' .. package.path
--~ print(package.path)

package.loaded['scite_luarocks'] = nil
local scite_luarocks = require 'scite_luarocks'
--~ local yaml = scite_luarocks.install_and_require('yaml','lua-yaml')
--~ local json = scite_luarocks.install_and_require('lunajson')

dofile(props['SciteUserHome'] .. '/.scite/scite_themes/scite_themes.lua')
