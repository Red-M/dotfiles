potato_match = { "application.process.host", "equals", "potato" }

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 384000,
    ["alsa.rate"] = 384000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "32768/384000",
    -- ["audio.allowed-rates"] = "48000,384000",
    ["audio.format"] = "S32LE",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*input.usb-Creative_Technology_Ltd_Sound_BlasterX_G6*" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 192000,
    ["alsa.rate"] = 192000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "16384/192000",
    -- ["audio.allowed-rates"] = "48000,192000,384000",
    ["audio.format"] = "S32LE",
  }
})
-- table.insert(alsa_monitor.rules, {
--   matches = {
--     {
--       { "device.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6*" },
--     },
--   },
--   apply_properties = {
--     ["device.profile-set"] = "sb-omni-surround-5.1.conf",
--   }
-- })

table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00*" },
    },
  },
  apply_properties = {
    ["node.description"] = "Music SoundBlasterX G6",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_6B00*" },
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


