extends Node

# Signals ##########################################################################################

signal display_fps_updated(display_fps: bool)
signal fov_updated(new_fov: float)
signal shadow_bias_updated(new_bias: float)
signal ssr_updated(enabled: bool, steps: int)
signal ssao_updated(enabled: bool)
signal ssil_updated(enabled: bool)
signal sdfgi_updated(enabled: bool)
signal glow_updated(enabled: bool)
signal volumetric_fog_updated(enabled: bool)

# Interface settings ###############################################################################

func set_ui_scale(value: Vector2i) -> void:
  get_tree().root.set_content_scale_size(value)

func set_display_fps(value: bool) -> void:
  display_fps_updated.emit(value)

# Video settings ###################################################################################

func set_resolution_scale(value: float) -> void:
  RenderingServer.viewport_set_scaling_3d_scale(
    get_viewport().get_viewport_rid(), value
  )

func set_scaling_mode(value: int) -> void:
  match value:
    1:
      RenderingServer.viewport_set_scaling_3d_mode(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR
      )
    _, 0:
      RenderingServer.viewport_set_scaling_3d_mode(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR
      )

func set_fsr_sharpness(value: float) -> void:
  RenderingServer.viewport_set_fsr_sharpness(get_viewport().get_viewport_rid(), value)

func set_window_mode(value: int) -> void:
  match value:
    1:
      DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    2:
      DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    _, 0:
      DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_vsync_mode(value: int) -> void:
  # Missing:
  # DisplayServer.VSYNC_MAILBOX
  match value:
    1:
      DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
    2:
      DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    _, 0:
      DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func set_msaa(value: int) -> void:
  match value:
    1:
      RenderingServer.viewport_set_msaa_3d(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_2X
      )
    2:
      RenderingServer.viewport_set_msaa_3d(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_4X
      )
    3:
      RenderingServer.viewport_set_msaa_3d(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_8X
      )
    _, 0:
      RenderingServer.viewport_set_msaa_3d(
        get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED
      )

func set_taa(value: bool) -> void:
  RenderingServer.viewport_set_use_taa(get_viewport().get_viewport_rid(), value)

func set_fxaa(value: bool) -> void:
  RenderingServer.viewport_set_screen_space_aa(get_viewport().get_viewport_rid(), int(value))

func set_fov(value: float) -> void:
  fov_updated.emit(value)

func set_max_fps(value: int) -> void:
  Engine.set_max_fps(value)

# Quality settings #################################################################################

func set_shadow_size(value: int) -> void:
  match value:
    1:
      RenderingServer.directional_shadow_atlas_set_size(1024, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 1024
      )
      shadow_bias_updated.emit(0.04)
    2:
      RenderingServer.directional_shadow_atlas_set_size(2048, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 2048
      )
      shadow_bias_updated.emit(0.03)
    3:
      RenderingServer.directional_shadow_atlas_set_size(4096, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 4096
      )
      shadow_bias_updated.emit(0.02)
    4:
      RenderingServer.directional_shadow_atlas_set_size(8192, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 8192
      )
      shadow_bias_updated.emit(0.01)
    5:
      RenderingServer.directional_shadow_atlas_set_size(16384, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 16384
      )
      shadow_bias_updated.emit(0.005)
    _, 0:
      RenderingServer.directional_shadow_atlas_set_size(512, true)
      RenderingServer.viewport_set_positional_shadow_atlas_size(
        get_viewport().get_viewport_rid(), 0
      )
      shadow_bias_updated.emit(0.06)

func set_shadow_filter(value: int) -> void:
  match value:
    1:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW
      )
    2:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_LOW
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_LOW
      )
    3:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM
      )
    4:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_HIGH
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_HIGH
      )
    5:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_ULTRA
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_SOFT_ULTRA
      )
    _, 0:
      RenderingServer.directional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_HARD
      )
      RenderingServer.positional_soft_shadow_filter_set_quality(
        RenderingServer.SHADOW_QUALITY_HARD
      )

func set_mesh_lod(value: int) -> void:
  match value:
    1:
      get_viewport().mesh_lod_threshold = 4.0
      # RenderingServer.reflection_probe_set_mesh_lod_threshold(
      #   get_viewport().get_viewport_rid(), 4.0
      # )
    2:
      get_viewport().mesh_lod_threshold = 2.0
      # RenderingServer.reflection_probe_set_mesh_lod_threshold(
      #   get_viewport().get_viewport_rid(), 2.0
      # )
    3:
      get_viewport().mesh_lod_threshold = 1.0
      # RenderingServer.reflection_probe_set_mesh_lod_threshold(
      #   get_viewport().get_viewport_rid(), 1.0
      # )
    4:
      get_viewport().mesh_lod_threshold = 0.0
      # RenderingServer.reflection_probe_set_mesh_lod_threshold(
      #   get_viewport().get_viewport_rid(), 0.0
      # )
    _, 0:
      get_viewport().mesh_lod_threshold = 8.0
      # RenderingServer.reflection_probe_set_mesh_lod_threshold(
      #   get_viewport().get_viewport_rid(), 8.0
      # )

# Effect settings ##################################################################################

func set_ss_reflections(value: int) -> void:
  match value:
    1:
      ssr_updated.emit(true, 8)
    2:
      ssr_updated.emit(true, 32)
    3:
      ssr_updated.emit(true, 64)
    _, 0:
      ssr_updated.emit(false, 0)

func set_ssao(value: int) -> void:
  match value:
    1:
      ssao_updated.emit(true)
      RenderingServer.environment_set_ssao_quality(
        RenderingServer.ENV_SSAO_QUALITY_VERY_LOW, true, 0.5, 2, 50, 300
      )
    2:
      ssao_updated.emit(true)
      RenderingServer.environment_set_ssao_quality(
        RenderingServer.ENV_SSAO_QUALITY_LOW, true, 0.5, 2, 50, 300
      )
    3:
      ssao_updated.emit(true)
      RenderingServer.environment_set_ssao_quality(
        RenderingServer.ENV_SSAO_QUALITY_MEDIUM, true, 0.5, 2, 50, 300
      )
    4:
      ssao_updated.emit(true)
      RenderingServer.environment_set_ssao_quality(
        RenderingServer.ENV_SSAO_QUALITY_HIGH, true, 0.5, 2, 50, 300
      )
    _, 0:
      ssao_updated.emit(false)

func set_ssil(value: int) -> void:
  match value:
    1:
      ssil_updated.emit(true)
      RenderingServer.environment_set_ssil_quality(
        RenderingServer.ENV_SSIL_QUALITY_VERY_LOW, true, 0.5, 4, 50, 300
      )
    2:
      ssil_updated.emit(true)
      RenderingServer.environment_set_ssil_quality(
        RenderingServer.ENV_SSIL_QUALITY_LOW, true, 0.5, 4, 50, 300
      )
    3:
      ssil_updated.emit(true)
      RenderingServer.environment_set_ssil_quality(
        RenderingServer.ENV_SSIL_QUALITY_MEDIUM, true, 0.5, 4, 50, 300
      )
    4:
      ssil_updated.emit(true)
      RenderingServer.environment_set_ssil_quality(
        RenderingServer.ENV_SSIL_QUALITY_HIGH, true, 0.5, 4, 50, 300
      )
    _, 0:
      ssil_updated.emit(false)

func set_sdfgi(value: int) -> void:
  match value:
    1:
      sdfgi_updated.emit(true)
      RenderingServer.gi_set_use_half_resolution(true)
    2:
      sdfgi_updated.emit(true)
      RenderingServer.gi_set_use_half_resolution(false)
    _, 0:
      sdfgi_updated.emit(false)

func set_glow(value: int) -> void:
  match value:
    1:
      glow_updated.emit(true)
      RenderingServer.environment_glow_set_use_bicubic_upscale(false)
    2:
      glow_updated.emit(true)
      RenderingServer.environment_glow_set_use_bicubic_upscale(true)
    _, 0:
      glow_updated.emit(false)

func set_volumetric_fog(value: int) -> void:
  match value:
    1:
      volumetric_fog_updated.emit(true)
      RenderingServer.environment_set_volumetric_fog_filter_active(false)
    2:
      volumetric_fog_updated.emit(true)
      RenderingServer.environment_set_volumetric_fog_filter_active(true)
    _, 0:
      volumetric_fog_updated.emit(false)


# Audio ############################################################################################

func set_master_volume(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func set_master_muted(value: bool) -> void:
  AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value)

func set_music_volume(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func set_music_muted(value: bool) -> void:
  AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value)

func set_sfx_volume(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func set_sfx_muted(value: bool) -> void:
  AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), value)
