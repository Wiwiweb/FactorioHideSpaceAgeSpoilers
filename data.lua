Common = require("src/common")
SpoilerContent = require("src/spoiler-content")
TechTree = require("src/tech-tree")

local only_factoriopedia = settings.startup["hsas-only-factoriopedia"].value

local hide_location = {}
local custom_hide_simulation = {}
for location_name, _location in pairs(Common.locations) do
  if settings.startup["hsas-reveal-" .. location_name] and not settings.startup["hsas-reveal-" .. location_name].value then
    hide_location[location_name] = true

    if SpoilerContent.custom_menu_simulations[location_name] then
      for _, name in pairs(SpoilerContent.custom_menu_simulations[location_name]) do
        custom_hide_simulation[name] = true
      end
    end
  end
end

-- Menu simulations
local data_raw_menu_simulations = data.raw["utility-constants"]["default"].main_menu_simulations
local simulations_to_hide = {}
for simulation_name, _ in pairs(data_raw_menu_simulations) do

  if custom_hide_simulation[simulation_name] then
    table.insert(simulations_to_hide, simulation_name)
    goto continue
  end

  for location_name, _ in pairs(hide_location) do
    if string.find(simulation_name, location_name) then
      table.insert(simulations_to_hide, simulation_name)
    end
  end

  ::continue::
end
log("Simulations hidden: " .. serpent.line(simulations_to_hide))
for _, simulation_name in pairs(simulations_to_hide) do
  data_raw_menu_simulations[simulation_name] = nil
end

---- Prototypes

--- Maps of sets
---@type table<string, table<string, boolean>>
local prototypes_to_hide = {}
---@type table<string, table<string, boolean>>
local prototypes_to_keep_revealed = {}

-- Custom hardcoded prototypes
for location_name, prototype_table in pairs(SpoilerContent.custom_prototypes) do
  local prototype_map = hide_location[location_name] and prototypes_to_hide or prototypes_to_keep_revealed
  for prototype_type, prototype_names in pairs(prototype_table) do
    prototype_map[prototype_type] = prototype_map[prototype_type] or {}
    for _, prototype_name in pairs(prototype_names) do
      prototype_map[prototype_type][prototype_name] = true
    end
  end
end

-- Prototypes placed by map gen settings (resources, cliffs, trees, rocks, tiles...)
for location_name, planet_name in pairs(SpoilerContent.planet) do
  local prototype_map = hide_location[location_name] and prototypes_to_hide or prototypes_to_keep_revealed
  prototype_map["planet"] = prototype_map["planet"] or {}
  prototype_map["planet"][planet_name] = true
  local map_gen = data.raw.planet[planet_name].map_gen_settings
  if map_gen then
    if map_gen.cliff_settings then
      prototype_map["cliff"] = prototype_map["cliff"] or {}
      prototype_map["cliff"][map_gen.cliff_settings.name] = true
    end
    if map_gen.autoplace_settings then
      if map_gen.autoplace_settings.tile and map_gen.autoplace_settings.tile.settings then
        for tile_name, _ in pairs(map_gen.autoplace_settings.tile.settings) do
          prototype_map["tile"] = prototype_map["tile"] or {}
          prototype_map["tile"][tile_name] = true
          local prototype = data.raw.tile[tile_name]
          if prototype.fluid then -- Offshore pump
            prototype_map["fluid"] = prototype_map["fluid"] or {}
            prototype_map["fluid"][prototype.fluid] = true
          end
        end
      end
      if map_gen.autoplace_settings.entity and map_gen.autoplace_settings.entity.settings then
        for entity_name, _ in pairs(map_gen.autoplace_settings.entity.settings) do
          local resource = data.raw.resource[entity_name]
          if resource then
            prototype_map["resource"] = prototype_map["resource"] or {}
            prototype_map["resource"][entity_name] = true
            if resource.minable then
              if resource.minable.results then
                for _, result in pairs(resource.minable.results) do
                  Common.add_result_and_placed_entity_to_map(result, prototype_map)
                end
              elseif resource.minable.result then
                Common.add_item_and_placed_entity_to_map(resource.minable.result, prototype_map)
              end
            end
          else
            prototype_map["unknown_entity"] = prototype_map["unknown_entity"] or {}
            prototype_map["unknown_entity"][entity_name] = true
          end
        end
      end
    end
  end
end

-- Prototypes from recipes unlocked at the start (keep them revealed)
for recipe_name, recipe in pairs(data.raw.recipe) do
  prototypes_to_keep_revealed["recipe"] = prototypes_to_keep_revealed["recipe"] or {}
  if recipe.enabled then
    Common.add_prototypes_from_recipe_to_map(recipe_name, prototypes_to_keep_revealed)
  end
end

-- Prototypes from tech
TechTree.add_tech_tree_prototypes(hide_location, prototypes_to_hide, prototypes_to_keep_revealed)


-- We gathered all the prototypes, now hide them
for prototype_type, prototype_set in pairs(prototypes_to_hide) do
  for prototype_name, _true in pairs(prototype_set) do
    if prototypes_to_keep_revealed[prototype_type] and prototypes_to_keep_revealed[prototype_type][prototype_name] then goto continue end
    local prototype
    if prototype_type == "unknown_entity" then
      prototype = Common.find_prototype_for_entity_name(prototype_name)
      if prototypes_to_keep_revealed[prototype.type] and prototypes_to_keep_revealed[prototype.type][prototype_name] then goto continue end
    else
      prototype = data.raw[prototype_type][prototype_name]
    end

    if only_factoriopedia then
      prototype.hidden_in_factoriopedia = true
    else
      prototype.hidden = true
    end

    ::continue::
  end
end

-- Remove hidden next_upgrade
if not only_factoriopedia then
  for type, _ in pairs(defines.prototypes.entity) do
    if data.raw[type] then
      for _name, prototype in pairs(data.raw[type]) do
        if prototype.next_upgrade then
          local upgrade_prototype = Common.find_prototype_for_entity_name(prototype.next_upgrade)
          if upgrade_prototype.hidden then
            prototype.next_upgrade = nil
          end
        end
      end
    end
  end
end
