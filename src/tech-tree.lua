local TechTree = {}

-- Automatically find prototypes by going through the tech tree

-- Create set of starting technologies to find end points (e.g. hiding Vulcanus should not go beyond Aquilo discovery tech)
local all_starting_technologies = {}
for _location_name, starting_technologies in pairs(SpoilerContent.starting_technologies) do
  for _, starting_technology_name in pairs(starting_technologies) do
    all_starting_technologies[starting_technology_name] = true
  end
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

-- Match technology with locations.
-- Tech can have multiple locations.
---@type table<string, table<string, boolean>>
local technology_to_locations = {}
local function set_locations_for_tech_and_children(location_name, technology_name)
  technology_to_locations[technology_name] = technology_to_locations[technology_name] or {}
  technology_to_locations[technology_name][location_name] = true

  -- Recusively call children 
  -- unless child is a starting technology for another location (Revisit this one if it's weird)
  -- or the child is already tagged with this location
  if technology_children[technology_name] then
    for _, child_technology_name in pairs(technology_children[technology_name]) do
      if not all_starting_technologies[child_technology_name]
        and not (technology_to_locations[child_technology_name] and technology_to_locations[child_technology_name][location_name]) then
        set_locations_for_tech_and_children(location_name, child_technology_name)
      end
    end
  end
end
for location_name, starting_technologies in pairs(SpoilerContent.starting_technologies) do
  for _, starting_technology_name in pairs(starting_technologies) do
    set_locations_for_tech_and_children(location_name, starting_technology_name)
  end
end

local function any_location_hidden(hide_location, locations)
  for location_name, _true in pairs(locations) do
    if hide_location[location_name] then return true end
  end
  return false
end

---@return string[]
local function get_recipes_from_tech(technology_name)
  local recipe_table = {}
  local technology = data.raw.technology[technology_name]
  if not technology then return recipe_table end
  if technology.effects then
    for _, effect in pairs(technology.effects) do
      if effect.type == "unlock-recipe" then
        table.insert(recipe_table, effect.recipe)
      end
    end
  end

  return recipe_table
end

---@return table<string, table<string, boolean>>
local function get_prototypes_from_recipe(recipe_name)
  local prototype_map = {}
  local recipe = data.raw.recipe[recipe_name]
  recipe.hidden_in_factoriopedia = true

  if recipe.results then
    for _, recipe_result in pairs(recipe.results) do
      if recipe_result.type == "fluid" then
        prototype_map["fluid"] = prototype_map["fluid"] or {}
        prototype_map["fluid"][recipe_result.name] = true
      elseif recipe_result.type == "item" then
        prototype = Util.find_prototype_for_item_name(recipe_result.name)
        prototype_map[prototype.type] = prototype_map[prototype.type] or {}
        prototype_map[prototype.type][recipe_result.name] = true
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
    end
  end

  return prototype_map
end

-- Debug: Set description
local function debug_set_description(hide_location, technology_name)
  local locations = technology_to_locations[technology_name]
  local s = ""
  for location, _ in pairs(locations) do
    s = s .. location .. ", "
  end
  s = s .. "[hide="..tostring(any_location_hidden(hide_location, locations)).."]"
  data.raw.technology[technology_name].localised_description = s
end

---@param hide_location table<string, boolean>
---@param prototypes_to_hide table<string, table<string, boolean>>
---@param prototypes_to_keep_revealed table<string, table<string, boolean>>
function TechTree.add_tech_tree_prototypes(hide_location, prototypes_to_hide, prototypes_to_keep_revealed)
  prototypes_to_hide["recipe"] = prototypes_to_hide["recipe"] or {}
  prototypes_to_keep_revealed["recipe"] = prototypes_to_keep_revealed["recipe"] or {}

  for technology_name, locations in pairs(technology_to_locations) do
    local prototype_map
    if any_location_hidden(hide_location, locations) then
      prototype_map = prototypes_to_hide
    else
      prototype_map = prototypes_to_keep_revealed
    end

    local recipes = get_recipes_from_tech(technology_name)
    for _, recipe_name in pairs(recipes) do
      prototype_map["recipe"][recipe_name] = true
      local result_map = get_prototypes_from_recipe(recipe_name)
      Util.merge_maps_of_sets(prototype_map, result_map)
    end

    debug_set_description(hide_location, technology_name)
  end
end

return TechTree
