local config = ... or {}

-- ensure config.properties is not nil
config.properties = config.properties or {}

-- cutils = require("common-utils")
-- config.properties = cutils.get_config_section("monitor.alsa.properties")



-- Core.require_api("mixer", function(mixer)
--   -- get the volume of node 35
--   local volume = mixer:call("get-volume", 35)
--
--   -- the return value of "get-volume" is a GVariant(a{sv}),
--   -- which gets translated to a Lua table
--   Debug.dump_table(volume)
-- end)

local om = ObjectManager {
  Interest {
    type = "device",
    Constraint { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00544362X*" },
  }
}
-- Debug.dump_table(Core.get_info())
om:connect("object-added", function (_, device)
  Log.warning(device, true)
end)

om:activate()







