local locations = {
  {
    name = "space",
    localised_name = {"item-group-name.space"}
  },
  {
    name = "vulcanus",
    localised_name = {"space-location-name.vulcanus"}
  },
  {
    name = "fulgora",
    localised_name = {"space-location-name.fulgora"}
  },
  {
    name = "gleba",
    localised_name = {"space-location-name.gleba"}
  },
  {
    name = "aquilo",
    localised_name = {"space-location-name.aquilo"}
  },
  {
    name = "endgame",
    localised_name = {"mod-setting-name.hsas-endgame"}
  },
}

local settings = {}
for i, location in pairs(locations) do
  table.insert(settings,
    {
      type = "bool-setting",
      name = "hsas-reveal-" .. location.name,
      localised_name = {"mod-setting-name.hsas-reveal", location.localised_name},
      setting_type = "startup",
      order = tostring(i),
      default_value = false,
    }
  )
end


data:extend(settings)
