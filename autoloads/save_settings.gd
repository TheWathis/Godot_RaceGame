extends Node

const SETTINGS_FILE: String = "user://settings.ini"
const DEFAULT_SETTINGS: Dictionary = {
  # Interface settings
  "ui_scale": 2,           # 0 = 66%, 1 = 80%, 2 = 100%, 3 = 133%, 4 = 200%
  "display_fps": false,
  # Video settings
  "resolution_scale": 1.0, # min: 0.25, max: 2.0
  "display_filter": 0,     # 0 = Bilinear, 1 = FSR 1.0
  "fsr_sharpness": 0.0,    # min: 0.0, max: 2.0
  "fullscreen": 0,         # 0 = Windowed, 1 = Borderless, 2 = Fullscreen
  "vsync": 0,              # 0 = Disabled, 1 = Adaptative, 2 = Enabled
  "msaa": 0,               # 0 = Disabled, 1 = 2x, 2 = 4x, 3 = 8x
  "taa": 0,                # 0 = Disabled, 1 = Enabled
  "fxaa": 0,               # 0 = Disabled, 1 = Enabled
  "fov": 90.0,             # min: 60.0, max: 120.0
  "max_fps": 60,           # min: 30, max: 255
  # Quality settings
  "shadow_size": 0,        # 0 = 512, 1 = 1024, 2 = 2048, 3 = 4096, 4 = 8192, 5 = 16384
  "shadow_filter": 0,      # 0 = hard, 1 = very low, 2 = low, 3 = medium, 4 = high, 5 = ultra
  "mesh_lod": 0,           # 0 = low, 1 = medium, 2 = high, 3 = ultra
  # Effect settings
  "ss_reflections": 0,     # 0 = disabled, 1 = low, 2 = medium, 3 = high
  "ssao": 0,               # 0 = disabled, 1 = very low, 2 = low, 3 = medium, 4 = high
  "ssil": 0,               # 0 = disabled, 1 = very low, 2 = low, 3 = medium, 4 = high
  "sdfgi": 0,              # 0 = disabled, 1 = low, 2 = high
  "glow": 0,               # 0 = disabled, 1 = low, 2 = high
  "volumetric_fog": 0,     # 0 = disabled, 1 = low, 2 = high
  "master_volume": 0.0,    # min: -80.0, max: +6.0
  "master_muted": false,   # false = unmuted, true = muted
  "music_volume": 0.0,     # min: -80.0, max: +6.0
  "music_muted": false,    # false = unmuted, true = muted
  "sfx_volume": 0.0,       # min: -80.0, max: +6.0
  "sfx_muted": false,      # false = unmuted, true = muted
}

var game_settings: Dictionary = DEFAULT_SETTINGS.duplicate(true)

func _ready() -> void:
  load_data()
  
  var viewport_size: Vector2i = Vector2i(
    ProjectSettings.get_setting(&"display/window/size/viewport_width"),
    ProjectSettings.get_setting(&"display/window/size/viewport_height")
  )
  if game_settings["ui_scale"] == 0: # Smaller (66%)
    viewport_size *= 1.5
  elif game_settings["ui_scale"] == 1: # Small (80%)
    viewport_size *= 1.25
  elif game_settings["ui_scale"] == 2: # Medium (100%) (default)
    viewport_size *= 1.0
  elif game_settings["ui_scale"] == 3: # Large (133%)
    viewport_size *= 0.75
  elif game_settings["ui_scale"] == 4: # Larger (200%)
    viewport_size *= 0.5
  
  GlobalSettings.set_ui_scale(viewport_size)
  GlobalSettings.set_display_fps(game_settings["display_fps"])
  GlobalSettings.set_resolution_scale(game_settings["resolution_scale"])
  GlobalSettings.set_scaling_mode(game_settings["display_filter"])
  GlobalSettings.set_fsr_sharpness(2.0 - game_settings["fsr_sharpness"])
  GlobalSettings.set_window_mode(game_settings["fullscreen"])
  GlobalSettings.set_vsync_mode(game_settings["vsync"])
  GlobalSettings.set_msaa(game_settings["msaa"])
  GlobalSettings.set_taa(game_settings["taa"] == 1)
  GlobalSettings.set_fxaa(game_settings["fxaa"] == 1)
  GlobalSettings.set_fov(game_settings["fov"])
  GlobalSettings.set_max_fps(0)#game_settings["max_fps"])
  GlobalSettings.set_shadow_size(game_settings["shadow_size"])
  GlobalSettings.set_shadow_filter(game_settings["shadow_filter"])
  GlobalSettings.set_mesh_lod(game_settings["mesh_lod"])
  GlobalSettings.set_ss_reflections(game_settings["ss_reflections"])
  GlobalSettings.set_ssao(game_settings["ssao"])
  GlobalSettings.set_ssil(game_settings["ssil"])
  GlobalSettings.set_sdfgi(game_settings["sdfgi"])
  # GlobalSettings.set_glow(game_settings["glow"])
  # GlobalSettings.set_volumetric_fog(game_settings["volumetric_fog"])
  GlobalSettings.set_master_volume(game_settings["master_volume"])
  GlobalSettings.set_master_muted(game_settings["master_muted"])
  GlobalSettings.set_music_volume(game_settings["music_volume"])
  GlobalSettings.set_music_muted(game_settings["music_muted"])
  GlobalSettings.set_sfx_volume(game_settings["sfx_volume"])
  GlobalSettings.set_sfx_muted(game_settings["sfx_muted"])


## Load the settings from the settings file
func load_data() -> void:
  if not FileAccess.file_exists(SETTINGS_FILE):
    save_data()
  else:
    var file: FileAccess = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
    game_settings.merge(file.get_var(), true)
    file.close()


## Save the current settings to the settings file
func save_data() -> void:
  var file: FileAccess = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
  file.store_var(game_settings)
  file.close()
