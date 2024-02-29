table.insert (bluez_monitor.rules, {
    matches = {
        {
            { "node.description", "matches", "FiiO.*" },
        },
    },
    apply_properties = {
        ["bluez5.default.rate"] = 48000
    }
})

