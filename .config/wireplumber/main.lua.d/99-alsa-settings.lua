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
      { "node.name", "equals", "alsa_output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6_6B00664368X-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 384000,
    ["alsa.rate"] = 384000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "16384/384000",
    ["node.description"] = "Game SoundBlasterX G6",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Creative_Technology_Ltd_Sound_BlasterX_G6_2C005443621-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["audio.rate"] = 384000,
    ["alsa.rate"] = 384000,
    ["alsa.resolution_bits"] = 32,
    ["node.max-latency"] = "16384/384000",
    ["node.description"] = "Music SoundBlasterX G6",
  }
})
table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.pci-0000_13_00.4.pro-output-0" },
    },
  },
  apply_properties = {
    ["node.description"] = "Voice Gigabyte Motherboard Onboard",
  }
})

