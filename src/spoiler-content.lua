local SpoilerContent = {}

SpoilerContent.menu_simulations = {
  space = {"platform_science"},
  vulcanus = {"vulcanus_lava_forge", "vulcanus_crossing"},
  fulgora = {"fulgora_city_crossing", "fulgora_nightfall"},
  gleba = {"gleba_pentapod_ponds", "gleba_egg_escape", "gleba_agri_towers"},
  aquilo = {"aquilo_send_help"},
  endgame = {},
}

SpoilerContent.starting_technologies = {
  nauvis = {"electronics", "steam-power"},
  space = {"space-platform"},
  vulcanus = {"planet-discovery-vulcanus"},
  fulgora = {"planet-discovery-fulgora"},
  gleba = {"planet-discovery-gleba"},
  aquilo = {"planet-discovery-aquilo"},
  endgame = {"promethium-science-pack"},
}

SpoilerContent.planet = {
  nauvis = "nauvis",
  vulcanus = "vulcanus",
  fulgora = "fulgora",
  gleba = "gleba",
  aquilo = "aquilo",
}

SpoilerContent.custom_prototypes = {
  space = {
    ["asteroid-chunk"] = {"metallic-asteroid-chunk", "carbonic-asteroid-chunk", "oxide-asteroid-chunk"},
    ["item"] = {"metallic-asteroid-chunk", "carbonic-asteroid-chunk", "oxide-asteroid-chunk"},
    ["space-connection"] = {"nauvis-vulcanus", "nauvis-fulgora", "nauvis-gleba"},
    ["tile"] = {"empty-space"},
  },
  vulcanus = {
    ["item"] = {"tungsten-ore", "calcite"},
    ["fluid"] = {"lava"},
    ["segmented-unit"] = {"small-demolisher", "medium-demolisher", "big-demolisher"},
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["planet"] = {"vulcanus"},
    ["space-connection"] = {"nauvis-vulcanus", "vulcanus-gleba"},
  },
  fulgora = {
    ["item"] = {"scrap"},
    ["ammo-category"] = {"tesla"},
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["planet"] = {"fulgora"},
    ["space-connection"] = {"nauvis-fulgora", "gleba-fulgora"},
  },
  gleba = {
    ["capsule"] = {"yumako", "jellynut"},
    ["unit"] = {
      "small-wriggler-pentapod", "medium-wriggler-pentapod", "big-wriggler-pentapod",
      "small-wriggler-pentapod-premature", "medium-wriggler-pentapod-premature", "big-wriggler-pentapod-premature",
    },
    ["spider-unit"] = {
      "small-strafer-pentapod", "medium-strafer-pentapod", "big-strafer-pentapod",
      "small-stomper-pentapod", "medium-stomper-pentapod", "big-stomper-pentapod",
    },
    ["unit-spawner"] = {"gleba-spawner", "gleba-spawner-small"},
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["planet"] = {"gleba"},
    ["space-connection"] = {"nauvis-gleba", "vulcanus-gleba", "gleba-fulgora"},
  },
  aquilo = {
    ["fluid"] = {"ammoniacal-solution", "fluorine", "lithium-brine", "fusion-plasma"},
    ["ammo-category"] = {"railgun"},
    ["asteroid"] = {"big-metallic-asteroid", "big-carbonic-asteroid", "big-oxide-asteroid"},
    ["planet"] = {"aquilo"},
    ["space-connection"] = {"gleba-aquilo", "fulgora-aquilo"}
  },
  endgame = {
    ["asteroid"] = {
      "huge-metallic-asteroid", "huge-carbonic-asteroid", "huge-oxide-asteroid",
      "small-promethium-asteroid", "medium-promethium-asteroid", "big-promethium-asteroid", "huge-promethium-asteroid",
    },
    ["asteroid-chunk"] = {"promethium-asteroid-chunk"},
    ["item"] = {"promethium-asteroid-chunk"},
    ["space-location"] = {"solar-system-edge", "shattered-planet"},
    ["space-connection"] = {"aquilo-solar-system-edge", "solar-system-edge-shattered-planet"},
  },
}

return SpoilerContent
