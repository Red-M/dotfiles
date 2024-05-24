local config = ... or {}

-- ensure config.properties is not nil
config.properties = config.properties or {}

-- cutils = require("common-utils")
-- config.properties = cutils.get_config_section("context.properties")
config.properties["default.clock.rate"] = 384000
config.properties["default.clock.allowed-rates"] = { 44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000 }
config.properties["clock.rate"] = 384000
config.properties["clock.allowed-rates"] = { 44100, 48000, 88200, 96000, 176400, 192000, 352800, 384000 }

