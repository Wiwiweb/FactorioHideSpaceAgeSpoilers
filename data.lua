SpoilerContent = require("spoiler-content")


local function find_prototype_for_name(name, types)
  for type, _prototypes in pairs(types) do
    if data.raw[type] then
      local prototype = data.raw[type][name]
      if prototype then return prototype end
    else
      log("Type in define but doesn't exist? " .. type)
    end
  end
  error("Unknown prototype type for: " .. name)
end

local function find_prototype_for_item_name(item_name)
  return find_prototype_for_name(item_name, defines.prototypes.item)
end

local function find_prototype_for_entity_name(entity_name)
  return find_prototype_for_name(entity_name, defines.prototypes.entity)
end


local locations_to_hide = {}
for location_name, _ in pairs(SpoilerContent.starting_technology) do
  if settings.startup["hsas-reveal-" .. location_name] and settings.startup["hsas-reveal-" .. location_name].value == false then
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

-- Hide all things placed by map gen settings (resources, cliffs, trees, rocks, tiles...)

for location_name, planet_name in pairs(SpoilerContent.planet) do
  if locations_to_hide[location_name] then
    local map_gen = data.raw.planet[planet_name].map_gen_settings
    if map_gen then
      if map_gen.cliff_settings then
        data.raw.cliff[map_gen.cliff_settings.name].hidden_in_factoriopedia = true
      end
      if map_gen.autoplace_controls then
        for autoplace_control_name, _autoplace_control in pairs(map_gen.autoplace_controls) do
          local resource = data.raw.resource[autoplace_control_name]
          if resource then
            resource.hidden_in_factoriopedia = true
          end
        end
      end
      if map_gen.autoplace_settings then
        if map_gen.autoplace_settings.tile and map_gen.autoplace_settings.tile.settings then
          for tile_name, _ in pairs(map_gen.autoplace_settings.tile.settings) do
            data.raw.tile[tile_name].hidden_in_factoriopedia = true
          end
        end
        if map_gen.autoplace_settings.entity and map_gen.autoplace_settings.entity.settings then
          for entity_name, _ in pairs(map_gen.autoplace_settings.entity.settings) do
            local prototype = find_prototype_for_entity_name(entity_name)
            prototype.hidden_in_factoriopedia = true
          end
        end
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

local function hide_recipe_and_results(recipe_name)
  local recipe = data.raw.recipe[recipe_name]
  recipe.hidden_in_factoriopedia = true

  if recipe.results then
    for _, recipe_result in pairs(recipe.results) do
      if recipe_result.type == "fluid" then
        data.raw.fluid[recipe_result.name].hidden_in_factoriopedia = true
      elseif recipe_result.type == "item" then
        local item = find_prototype_for_item_name(recipe_result.name)
        item.hidden_in_factoriopedia = true
        if item.place_result then
          local place_result = find_prototype_for_entity_name(item.place_result)
          place_result.hidden_in_factoriopedia = true
        end
        if item.plant_result then
          data.raw.plant[item.plant_result].hidden_in_factoriopedia = true
        end
        if item.place_as_tile then
          data.raw.tile[item.place_as_tile.result].hidden_in_factoriopedia = true
        end
      end
    end
  end
end

local function hide_prototypes_from_tech_and_children(technology_name)
  local technology = data.raw.technology[technology_name]
  if not technology then return end
  if technology.effects then
    for _, effect in pairs(technology.effects) do
      if effect.type == "unlock-recipe" then
        hide_recipe_and_results(effect.recipe)
      end
    end
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
