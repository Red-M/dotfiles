
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


