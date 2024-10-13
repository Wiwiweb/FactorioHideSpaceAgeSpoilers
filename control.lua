Common = require("src/common")

local tech_to_location_start = {}
for location_name, starting_technologies in pairs(Common.starting_technologies) do
  for _, starting_technology_name in pairs(starting_technologies) do
    tech_to_location_start[starting_technology_name] = location_name
  end
end

script.on_event(defines.events.on_research_finished, function(event)
  if storage.already_reminded then return end
  local location_name = tech_to_location_start[event.research.name]
  if location_name and settings.startup["hsas-reveal-" .. location_name].value == false then
    game.print({"hide-space-age-spoilers.mod-settings-reminder", Common.locations[location_name].localised_name})
    storage.already_reminded = true
  end
end)
