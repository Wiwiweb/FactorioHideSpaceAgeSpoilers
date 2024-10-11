SpoilerContent = {}

SpoilerContent.menu_simulations = {
  space = {"platform_science"},
  vulcanus = {"vulcanus_lava_forge", "vulcanus_crossing"},
  fulgora = {"fulgora_city_crossing", "fulgora_nightfall"},
  gleba = {"gleba_pentapod_ponds", "gleba_egg_escape", "gleba_agri_towers"},
  aquilo = {"aquilo_send_help"},
  endgame = {},
}

SpoilerContent.starting_technology = {
  space = "space-platform",
  vulcanus = "planet-discovery-vulcanus",
  fulgora = "planet-discovery-fulgora",
  gleba = "planet-discovery-gleba",
  aquilo = "planet-discovery-aquilo",
  endgame = "promethium-science-pack",
}

SpoilerContent.custom_prototypes = {
  space = {},
  vulcanus = {
    ["segmented-unit"] = {"small-demolisher", "medium-demolisher", "big-demolisher"},
  },
  fulgora = {},
  gleba = {},
  aquilo = {},
  endgame = {},
}

return SpoilerContent
