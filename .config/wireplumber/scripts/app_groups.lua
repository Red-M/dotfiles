local config = ... or {}

metadata_om = ObjectManager {
  Interest {
    type = "metadata",
    Constraint { "metadata.name", "=", "default" },
  }
}

for _, r in ipairs(config.rules or {}) do
  r.interests = {}
  for _, i in ipairs(r.matches) do
    local interest_desc = { type = "properties" }
    for _, c in ipairs(i) do
      c.type = "pw"
      table.insert(interest_desc, Constraint(c))
    end
    local interest = Interest(interest_desc)
    table.insert(r.interests, interest)
  end
  r.matches = nil
end

function rulesApplyProperties(properties)
  for _, r in ipairs(config.rules or {}) do
    if r.apply_properties then
      for _, interest in ipairs(r.interests) do
        if interest:matches(properties) then
          for k, v in pairs(r.apply_properties) do
            properties[k] = v
          end
        end
      end
    end
  end
end

app_groups_om = ObjectManager {
  Interest { type = "node" }
}

app_groups_om:connect("object-added", function (om, client)
  local id = client["bound-id"]
  local properties = client["properties"]

  if properties then
    rulesApplyProperties(properties)
    print(client, "App Groups: " .. id)
  end
end)

metadata_om:activate()
app_groups_om:activate()




