local SpoilerContent = {}

SpoilerContent.custom_menu_simulations = {
  space = {"platform_science"},
  gleba = {"nauvis_biolab"},
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
    ["segmented-unit"] = {"small-demolisher", "medium-demolisher", "big-demolisher"},
    ["simple-entity"] = {
      "vulcanus-chimney-short", "vulcanus-chimney-cold", "vulcanus-chimney-faded", -- Unused entities
      "small-demolisher-corpse", "medium-demolisher-corpse", "big-demolisher-corpse",
    },
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["space-connection"] = {"nauvis-vulcanus", "vulcanus-gleba"},
  },
  fulgora = {
    ["ammo-category"] = {"tesla"},
    ["lightning"] = {"lightning"},
    ["simple-entity"] = {
      "fulgurite-small", -- Unused entity
    },
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["space-connection"] = {"nauvis-fulgora", "gleba-fulgora"},
  },
  gleba = {
    ["assembling-machine"] = {"captive-biter-spawner"},
    ["capsule"] = {"yumako", "jellynut"}, -- We could check for the minable properties of autoplace entities, but I'm tired
    ["tree"] = {
      "slipstack", "funneltrunk", "hairyclubnub", "teflilly", "lickmaw",
      "stingfrond", "boompuff", "sunnycomb", "cuttlepop", "water-cane"}, -- We could check every tree's autoplace, but I'm tired
    ["unit"] = {
      "small-wriggler-pentapod", "medium-wriggler-pentapod", "big-wriggler-pentapod",
      "small-wriggler-pentapod-premature", "medium-wriggler-pentapod-premature", "big-wriggler-pentapod-premature",
    },
    ["spider-unit"] = {
      "small-strafer-pentapod", "medium-strafer-pentapod", "big-strafer-pentapod",
      "small-stomper-pentapod", "medium-stomper-pentapod", "big-stomper-pentapod",
    },
    ["unit-spawner"] = {"gleba-spawner", "gleba-spawner-small"},
    ["simple-entity"] = {"small-stomper-shell", "medium-stomper-shell", "big-stomper-shell"},
    ["asteroid"] = {
      "small-metallic-asteroid", "medium-metallic-asteroid",
      "small-carbonic-asteroid", "medium-carbonic-asteroid",
      "small-oxide-asteroid", "medium-oxide-asteroid",
    },
    ["space-connection"] = {"nauvis-gleba", "vulcanus-gleba", "gleba-fulgora"},
  },
  aquilo = {
    ["fluid"] = {"fusion-plasma"},
    ["ammo-category"] = {"railgun"},
    ["asteroid"] = {"big-metallic-asteroid", "big-carbonic-asteroid", "big-oxide-asteroid"},
    ["space-connection"] = {"gleba-aquilo", "fulgora-aquilo"},
    ["tile"] = {"dust-crests", "dust-flat", "dust-lumpy", "dust-patchy"}, -- Unused tiles, but marked as Aquilo
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
