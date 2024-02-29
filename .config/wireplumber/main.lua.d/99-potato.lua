table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6*" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 384000,
    ["alsa.rate"] = 384000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "32768/384000",
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
      { "node.name", "matches", "*usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C00544362X*" },
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


