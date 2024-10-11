SpoilerContent = require("spoiler-content")

local locations_to_hide = {}
for location_name, _ in pairs(SpoilerContent.prototypes) do
  if settings.startup["hsas-reveal-"..location_name] and settings.startup["hsas-reveal-"..location_name].value == false then
    locations_to_hide[location_name] = true
  end
end

local data_raw_menu_simulations = data.raw["utility-constants"]["default"].main_menu_simulations
for location_name, menu_simulation_names in pairs(SpoilerContent.menu_simulations) do
  if locations_to_hide[location_name] then
    for _, menu_simulation_name in pairs(menu_simulation_names) do
      data_raw_menu_simulations[menu_simulation_name] = nil
    end
  end
end

for location_name, prototype_table in pairs(SpoilerContent.prototypes) do
  if locations_to_hide[location_name] then
    for prototype_type, prototype_names in pairs(prototype_table) do
      for _, prototype_name in pairs(prototype_names) do
        data.raw[prototype_type][prototype_name].hidden_in_factoriopedia = true
      end
    end
  end
end
