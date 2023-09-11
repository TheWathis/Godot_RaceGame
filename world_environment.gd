extends WorldEnvironment


@onready var directional_light: DirectionalLight3D = $DirectionalLight3D


func _ready() -> void:
  if not GlobalSettings.shadow_bias_updated.is_connected(_on_shadow_bias_updated):
    GlobalSettings.shadow_bias_updated.connect(_on_shadow_bias_updated)
  if not GlobalSettings.ssr_updated.is_connected(_on_ssr_updated):
    GlobalSettings.ssr_updated.connect(_on_ssr_updated)
  if not GlobalSettings.ssao_updated.is_connected(_on_ssao_updated):
    GlobalSettings.ssao_updated.connect(_on_ssao_updated)
  if not GlobalSettings.ssil_updated.is_connected(_on_ssil_updated):
    GlobalSettings.ssil_updated.connect(_on_ssil_updated)
  if not GlobalSettings.sdfgi_updated.is_connected(_on_sdfgi_updated):
    GlobalSettings.sdfgi_updated.connect(_on_sdfgi_updated)
  if not GlobalSettings.glow_updated.is_connected(_on_glow_updated):
    GlobalSettings.glow_updated.connect(_on_glow_updated)
  if not GlobalSettings.volumetric_fog_updated.is_connected(_on_volumetric_fog_updated):
    GlobalSettings.volumetric_fog_updated.connect(_on_volumetric_fog_updated)

  match SaveSettings.game_settings["shadow_size"]:
    1:
      directional_light.shadow_bias = 0.04
    2:
      directional_light.shadow_bias = 0.03
    3:
      directional_light.shadow_bias = 0.02
    4:
      directional_light.shadow_bias = 0.01
    5:
      directional_light.shadow_bias = 0.005
    _, 0:
      directional_light.shadow_bias = 0.06
  
  match SaveSettings.game_settings["ss_reflections"]:
    1:
      environment.ssr_enabled = true
      environment.ssr_max_steps = 8
    2:
      environment.ssr_enabled = true
      environment.ssr_max_steps = 32
    3:
      environment.ssr_enabled = true
      environment.ssr_max_steps = 56
    _, 0:
      environment.ssr_enabled = false
      environment.ssr_max_steps = 0
    
  environment.ssao_enabled = SaveSettings.game_settings["ssao"] >= 1
  environment.ssil_enabled = SaveSettings.game_settings["ssil"] >= 1
  environment.sdfgi_enabled = SaveSettings.game_settings["sdfgi"] >= 1
  environment.glow_enabled = SaveSettings.game_settings["glow"] >= 1
  environment.volumetric_fog_enabled = SaveSettings.game_settings["volumetric_fog"] >= 1


func _on_shadow_bias_updated(new_bias: float) -> void:
  directional_light.shadow_bias = new_bias

func _on_ssr_updated(new_enabled: bool, new_max_steps: int) -> void:
  environment.ssr_enabled = new_enabled
  environment.ssr_max_steps = new_max_steps

func _on_ssao_updated(new_enabled: bool) -> void:
  environment.ssao_enabled = new_enabled

func _on_ssil_updated(new_enabled: bool) -> void:
  environment.ssil_enabled = new_enabled

func _on_sdfgi_updated(new_enabled: bool) -> void:
  environment.sdfgi_enabled = new_enabled

func _on_glow_updated(new_enabled: bool) -> void:
  environment.glow_enabled = new_enabled

func _on_volumetric_fog_updated(new_enabled: bool) -> void:
  environment.volumetric_fog_enabled = new_enabled


