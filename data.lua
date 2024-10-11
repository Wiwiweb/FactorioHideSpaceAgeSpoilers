SpoilerContent = require("spoiler-content")

local locations_to_hide = {}
for location_name, _ in pairs(SpoilerContent.starting_technology) do
  if settings.startup["hsas-reveal-"..location_name] and settings.startup["hsas-reveal-"..location_name].value == false then
    locations_to_hide[location_name] = true
  end
end

-- Menu simulations
local data_raw_menu_simulations = data.raw["utility-constants"]["default"].main_menu_simulations
for location_name, menu_simulation_names in pairs(SpoilerContent.menu_simulations) do
  if locations_to_hide[location_name] then
    for _, menu_simulation_name in pairs(menu_simulation_names) do
      data_raw_menu_simulations[menu_simulation_name] = nil
    end
  end
end

-- Custom hardcoded prototypes
for location_name, prototype_table in pairs(SpoilerContent.custom_prototypes) do
  if locations_to_hide[location_name] then
    for prototype_type, prototype_names in pairs(prototype_table) do
      for _, prototype_name in pairs(prototype_names) do
        data.raw[prototype_type][prototype_name].hidden_in_factoriopedia = true
      end
    end
  end
end

-- Automatically find prototypes by going through the tech tree

-- Create set of starting technologies to find end points (e.g. hiding Vulcanus should not go beyond Aquilo discovery tech)
local all_starting_technologies = {}
for _location_name, starting_technology_name in pairs(SpoilerContent.starting_technology) do
  all_starting_technologies[starting_technology_name] = true
end

-- Build inverted dependency graph
local technology_children = {}
for technology_name, technology in pairs(data.raw.technology) do
  if technology.prerequisites then
    for _, prerequisite_name in pairs(technology.prerequisites) do
      technology_children[prerequisite_name] = technology_children[prerequisite_name] or {}
      table.insert(technology_children[prerequisite_name], technology_name)
    end
  end
end

local function hide_prototypes_from_tech_and_children(technology_name)
  local technology = data.raw.technology[technology_name]
  if not technology then return end
  for _, effect in pairs(technology.effects) do
    -- TODO
  end

  -- Recusively call children unless child is a starting technology for another location
  if technology_children[technology_name] then
    for _, child_technology_name in pairs(technology_children[technology_name]) do
      if not all_starting_technologies[child_technology_name] then
        hide_prototypes_from_tech_and_children(child_technology_name)
      end
    end
  end
end

for location_name, starting_technology_name in pairs(SpoilerContent.starting_technology) do
  if locations_to_hide[location_name] then
    hide_prototypes_from_tech_and_children(starting_technology_name)
  end
end
