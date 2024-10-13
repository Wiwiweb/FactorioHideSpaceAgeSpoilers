Common = require("src/common")

local settings = {}
local i = 1
for location_name, location in pairs(Common.locations) do
  table.insert(settings,
    {
      type = "bool-setting",
      name = "hsas-reveal-" .. location_name,
      localised_name = {"mod-setting-name.hsas-reveal", location.localised_name},
      setting_type = "startup",
      order = tostring(i),
      hidden = location.hidden or false,
      default_value = location.default_value or false,
    }
  )
  i = i + 1
end


data:extend(settings)
