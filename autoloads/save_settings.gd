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
}

var game_settings: Dictionary = DEFAULT_SETTINGS.duplicate(true)

func _ready() -> void:
  load_data()
  # Graphics
  GlobalSettings.toggle_full_screen(game_settings["fullscreen_on"])
  GlobalSettings.toggle_display_fps(game_settings["display_fps"])
  GlobalSettings.toggle_vsync(game_settings["vsync_on"])
  GlobalSettings.set_max_fps(game_settings["max_fps"])
  ## Anti-aliasing
  GlobalSettings.toggle_use_taa(game_settings["use_taa"])
  GlobalSettings.set_msaa_2d(game_settings["msaa_2d"])
  GlobalSettings.set_msaa_3d(game_settings["msaa_3d"])
  GlobalSettings.set_screen_space_aa(game_settings["screen_space_aa"])
  # Audio
  GlobalSettings.toggle_master_mute(game_settings["master_mute"])
  GlobalSettings.toggle_music_mute(game_settings["music_mute"])
  GlobalSettings.toggle_sfx_mute(game_settings["sfx_mute"])
  GlobalSettings.update_master_volume(game_settings["master_volume"])
  GlobalSettings.update_music_volume(game_settings["music_volume"])
  GlobalSettings.update_sfx_volume(game_settings["sfx_volume"])


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
