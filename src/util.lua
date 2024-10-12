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
