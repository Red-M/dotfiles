
local app_groups = {["rules"] = {}}

table.insert(app_groups.rules, {
  matches = {
    {
      { "application.name", "equals", "Google Chrome" },
    },
  },
  apply_properties = {
    ["media.role"] = "Music",
  }
})


table.insert(app_groups.rules, {
  matches = {
    {
      { "application.process.binary", "equals", "Discord" },
    },
  },
  apply_properties = {
    ["media.role"] = "Communication",
  }
})




load_script("app_groups.lua", app_groups)



