local Util = {}

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

function Util.add_item_and_placed_entity_to_map(item_name, prototype_map)
  prototype = Util.find_prototype_for_item_name(item_name)
  prototype_map[prototype.type] = prototype_map[prototype.type] or {}
  prototype_map[prototype.type][item_name] = true
  if prototype.place_result then
    prototype_map["unknown_entity"] = prototype_map["unknown_entity"] or {}
    prototype_map["unknown_entity"][prototype.place_result] = true
  end
  if prototype.plant_result then
    prototype_map["plant"] = prototype_map["plant"] or {}
    prototype_map["plant"][prototype.plant_result] = true
  end
  if prototype.place_as_tile then
    prototype_map["tile"] = prototype_map["tile"] or {}
    prototype_map["tile"][prototype.place_as_tile.result] = true
  end
end

function Util.add_result_and_placed_entity_to_map(result, prototype_map)
  if result.type == "fluid" then
    prototype_map["fluid"] = prototype_map["fluid"] or {}
    prototype_map["fluid"][result.name] = true
  elseif result.type == "item" then
    Util.add_item_and_placed_entity_to_map(result.name, prototype_map)
  end
end

function Util.find_prototype_for_item_name(item_name)
  return find_prototype_for_name(item_name, defines.prototypes.item)
end

function Util.find_prototype_for_entity_name(entity_name)
  return find_prototype_for_name(entity_name, defines.prototypes.entity)
end

---@param set1 table<string, boolean>
---@param set2 table<string, boolean>
function Util.merge_sets(set1, set2)
  for set_key, _true in pairs(set2) do
    set1[set_key] = true
  end
end

---@param map1 table<string, table<string, boolean>>
---@param map2 table<string, table<string, boolean>>
function Util.merge_maps_of_sets(map1, map2)
  for map_key, _map_value_set in pairs(map2) do
    map1[map_key] = map1[map_key] or {}
    Util.merge_sets(map1[map_key], map2[map_key])
  end
end

return Util
