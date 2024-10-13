Util = require("src/util")
SpoilerContent = require("src/spoiler-content")
TechTree = require("src/tech-tree")

local hide_location = {}
for location_name, _ in pairs(SpoilerContent.starting_technologies) do
  if settings.startup["hsas-reveal-" .. location_name] then
    hide_location[location_name] = not settings.startup["hsas-reveal-" .. location_name].value
  end
end

-- Menu simulations
local data_raw_menu_simulations = data.raw["utility-constants"]["default"].main_menu_simulations
for location_name, menu_simulation_names in pairs(SpoilerContent.menu_simulations) do
  if hide_location[location_name] then
    for _, menu_simulation_name in pairs(menu_simulation_names) do
      data_raw_menu_simulations[menu_simulation_name] = nil
    end
  end
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
  local map_gen = data.raw.planet[planet_name].map_gen_settings
  if map_gen then
    if map_gen.cliff_settings then
      data.raw.cliff[map_gen.cliff_settings.name].hidden_in_factoriopedia = true
    end
    if map_gen.autoplace_controls then
      for autoplace_control_name, _autoplace_control in pairs(map_gen.autoplace_controls) do
        local resource = data.raw.resource[autoplace_control_name]
        if resource then
          prototype_map["resource"] = prototype_map["resource"] or {}
          prototype_map["resource"][autoplace_control_name] = true
          if resource.minable then
            if resource.minable.results then
              for _, result in pairs(resource.minable.results) do
                Util.add_result_and_placed_entity_to_map(result, prototype_map)
              end
            elseif resource.minable.result then
              Util.add_item_and_placed_entity_to_map(resource.minable.result, prototype_map)
            end
          end
        end
      end
    end
    if map_gen.autoplace_settings then
      if map_gen.autoplace_settings.tile and map_gen.autoplace_settings.tile.settings then
        for tile_name, _ in pairs(map_gen.autoplace_settings.tile.settings) do
          prototype_map["tile"] = prototype_map["tile"] or {}
          prototype_map["tile"][tile_name] = true
        end
      end
      if map_gen.autoplace_settings.entity and map_gen.autoplace_settings.entity.settings then
        for entity_name, _ in pairs(map_gen.autoplace_settings.entity.settings) do
          prototype_map["unknown_entity"] = prototype_map["unknown_entity"] or {}
          prototype_map["unknown_entity"][entity_name] = true
        end
      end
    end
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
      prototype = Util.find_prototype_for_entity_name(prototype_name)
      if prototypes_to_keep_revealed[prototype.type] and prototypes_to_keep_revealed[prototype.type][prototype_name] then goto continue end
    else
      prototype = data.raw[prototype_type][prototype_name]
    end

    prototype.hidden_in_factoriopedia = true

    ::continue::
  end
end
