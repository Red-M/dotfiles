local scite_lr = {}
package.loaded["scite_luarocks"] = scite_lr
local luarocks_site_config = {}
package.loaded["luarocks.luarocks.core.hardcoded"] = luarocks_site_config
luarocks_site_config.LUAROCKS_FORCE_CONFIG = true
luarocks_site_config.FORCE_CONFIG = true
luarocks_site_config.LUAROCKS_SYSCONFDIR = props['custom.scite.extdir'] .. "/.luarocks"
luarocks_site_config.LUAROCKS_ROCKS_TREE = props['custom.scite.extdir'] .. "/luarocks"
luarocks_site_config.LUAROCKS_ROCKS_SUBDIR = "rocks"
luarocks_site_config.link_lua_explicitly = true
luarocks_site_config.local_by_default = true
local luarocks_cfg = require "luarocks.core.cfg"
local luarocks_cmd = require "luarocks.cmd"
--~ _printf(package.path)
local commands = {
   init = "luarocks.cmd.init",
   pack = "luarocks.cmd.pack",
   unpack = "luarocks.cmd.unpack",
   build = "luarocks.cmd.build",
   install = "luarocks.cmd.install",
   search = "luarocks.cmd.search",
   list = "luarocks.cmd.list",
   remove = "luarocks.cmd.remove",
   make = "luarocks.cmd.make",
   download = "luarocks.cmd.download",
   path = "luarocks.cmd.path",
   show = "luarocks.cmd.show",
   new_version = "luarocks.cmd.new_version",
   lint = "luarocks.cmd.lint",
   write_rockspec = "luarocks.cmd.write_rockspec",
   purge = "luarocks.cmd.purge",
   doc = "luarocks.cmd.doc",
   upload = "luarocks.cmd.upload",
   config = "luarocks.cmd.config",
   which = "luarocks.cmd.which",
   test = "luarocks.cmd.test",
}

--~ luarocks_cmd.run_command('', commands, "luarocks.cmd.external", 'config')
function scite_lr.install_and_require(name,package_name)
    if package_name == nil then
        package_name = name
    end
    local ret_code,lib = pcall(require, name)
    if ret_code == false then
        luarocks_cmd.run_command('', commands, "luarocks.cmd.external", 'install','--tree',luarocks_site_config.LUAROCKS_ROCKS_TREE, package_name)
        ret_code,lib = pcall(require, name)
        if ret_code == false then
            print('Could not load library: ' .. name .. ', downloaded as ' .. package_name)
            print(lib)
        end
    end
    return lib
end

require "luarocks.loader"

return scite_lr
