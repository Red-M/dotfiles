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

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_07_00.6.HiFi__hw_Generic_1__sink" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 192000,
    ["alsa.rate"] = 192000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "16384/192000",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "alsa_output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 384000,
    ["alsa.rate"] = 384000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "16384/384000",
  }
})

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C005443621-00*" },
    },
  },
  apply_properties = {
    ["node.description"] = "Music SoundBlasterX G6",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_6B00664368X-00*" },
    },
  },
  apply_properties = {
    ["node.description"] = "Game SoundBlasterX G6",
  }
})


table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*pci-0000_13_00.4.*" },
    },
  },
  apply_properties = {
    ["node.description"] = "Voice Gigabyte Motherboard Onboard",
  }
})




