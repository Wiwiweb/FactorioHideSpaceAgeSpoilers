SpoilerContent = require("spoiler-content")

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

-- Hide all tiles from tile group
local tile_groups_to_hide = {}
for location_name, tile_groups in pairs(SpoilerContent.tile_groups) do
  if locations_to_hide[location_name] then
    for _, tile_group_name in pairs(tile_groups) do
      tile_groups_to_hide[tile_group_name] = true
    end
  end
end
for _tile_name, tile_prototype in pairs(data.raw.tile) do
  if tile_groups_to_hide[tile_prototype.subgroup] then
    tile_prototype.hidden_in_factoriopedia = true
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

local function find_prototype_for_name(name, types)
  for type, _prototypes in pairs(types) do
    if data.raw[type] then
      local prototype = data.raw[type][name]
      if prototype then return prototype end
    else
      log(type)
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
