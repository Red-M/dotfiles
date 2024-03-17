
alsa_monitor.enabled = true

table.insert (alsa_monitor.rules, {
  matches = {
    {
      -- Matches all sources.
      { "node.name", "matches", "alsa_input.*" },
    },
    {
      -- Matches all sinks.
      { "node.name", "matches", "alsa_output.*" },
    },
  },
  apply_properties = {
    ["session.suspend-timeout-seconds"] = 0,  -- 0 disables suspend
  },
})

table.insert (alsa_monitor.rules, {
  -- Rules for matching a device or node. It is an array of
  -- properties that all need to match the regexp. If any of the
  -- matches work, the actions are executed for the object.
  matches = {
    {
      -- This matches all cards.
      { "device.name", "matches", "alsa_card.*" },
    },
  },
  -- Apply properties on the matched object.
  apply_properties = {
    -- Use ALSA-Card-Profile devices. They use UCM or the profile
    -- configuration to configure the device and mixer settings.
    ["api.alsa.use-acp"] = true,

    -- Use UCM instead of profile when available. Can be
    -- disabled to skip trying to use the UCM profile.
    ["api.alsa.use-ucm"] = true,
    ["session.suspend-timeout-seconds"] = 0,  -- 0 disables suspend
  }
})

table.insert (alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "alsa_*.usb-*" },
    },
  },
  apply_properties = {
    -- USB audio interfaces can take a while to wake up from suspending
    ["session.suspend-timeout-seconds"] = 0,
  }
})

table.insert (alsa_monitor.rules, {
  matches = {
    {
      { "application.process.binary", "equals", "Discord" },
    },
  },
  apply_properties = {
    -- USB audio interfaces can take a while to wake up from suspending
    ["pulse.min.quantum"] = "1024/48000",
  }
})






