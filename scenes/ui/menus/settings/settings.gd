extends Control

# When the screen changes size, we need to update the 3D
# viewport quality setting. If we don't do this, the viewport will take
# the size from the main viewport.
var viewport_start_size: Vector2i = Vector2i(
  ProjectSettings.get_setting(&"display/window/size/viewport_width"),
  ProjectSettings.get_setting(&"display/window/size/viewport_height")
)

func _ready() -> void:
  %UIScaleOptionButton.selected = SaveSettings.game_settings["ui_scale"]
  %QualitySlider.value = SaveSettings.game_settings["resolution_scale"]
  %FilterOptionButton.selected = SaveSettings.game_settings["display_filter"]
  %FSRSharpnessSlider.value = 2.0 - SaveSettings.game_settings["fsr_sharpness"]
  %FullscreenOptionButton.selected = SaveSettings.game_settings["fullscreen"]
  %VsyncOptionButton.selected = SaveSettings.game_settings["vsync"]
  %TAAOptionButton.selected = SaveSettings.game_settings["taa"]
  %MSAAOptionButton.selected = SaveSettings.game_settings["msaa"]
  %FXAAOptionButton.selected = SaveSettings.game_settings["fxaa"]
  %FOVSlider.value = SaveSettings.game_settings["fov"]
  %ShadowSizeOptionButton.selected = SaveSettings.game_settings["shadow_size"]
  %ShadowFilterOptionButton.selected = SaveSettings.game_settings["shadow_filter"]
  %MeshLODOptionButton.selected = SaveSettings.game_settings["mesh_lod"]
  %SDFGIOptionButton.selected = SaveSettings.game_settings["sdfgi"]
  # %GlowOptionButton.selected = SaveSettings.game_settings["glow"]
  %SSAOOptionButton.selected = SaveSettings.game_settings["ssao"]
  %SSReflectionsOptionButton.selected = SaveSettings.game_settings["ss_reflections"]
  %SSILOptionButton.selected = SaveSettings.game_settings["ssil"]
  # %VolumetricFogOptionButton.selected = SaveSettings.game_settings["volumetric_fog"]

# Video settings.

func _on_ui_scale_option_button_item_selected(index: int) -> void:
  var new_size: Vector2i = viewport_start_size
  if index == 0: # Smaller (66%)
    new_size *= 1.5
  elif index == 1: # Small (80%)
    new_size *= 1.25
  elif index == 2: # Medium (100%) (default)
    new_size *= 1.0
  elif index == 3: # Large (133%)
    new_size *= 0.75
  elif index == 4: # Larger (200%)
    new_size *= 0.5
  
  GlobalSettings.set_ui_scale(new_size)
  SaveSettings.game_settings["ui_scale"] = index


func _on_quality_slider_value_changed(value: float) -> void:
  GlobalSettings.set_resolution_scale(value)
  SaveSettings.game_settings["resolution_scale"] = value


func _on_filter_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_scaling_mode(index)
  SaveSettings.game_settings["display_filter"] = index
  if index == 0: # Bilinear (Fastest)
    %FSRSharpnessLabel.visible = false
    %FSRSharpnessSlider.visible = false
  elif index == 1: # FSR 1.0 (Fast)
    %FSRSharpnessLabel.visible = true
    %FSRSharpnessSlider.visible = true


func _on_fsr_sharpness_slider_value_changed(value: float) -> void:
  GlobalSettings.set_fsr_sharpness(2.0 - value)
  SaveSettings.game_settings["fsr_sharpness"] = 2.0 - value


func _on_fullscreen_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_window_mode(index)
  SaveSettings.game_settings["fullscreen"] = index


func _on_vsync_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_vsync_mode(index)
  SaveSettings.game_settings["vsync"] = index


func _on_msaa_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_msaa(index)
  SaveSettings.game_settings["msaa"] = index


func _on_taa_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_taa(index == 1)
  SaveSettings.game_settings["taa"] = index


func _on_fxaa_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_fxaa(index == 1)
  SaveSettings.game_settings["fxaa"] = index


func _on_fov_slider_value_changed(value: float) -> void:
  GlobalSettings.set_fov(value)
  SaveSettings.game_settings["fov"] = value

# Quality settings.

func _on_shadow_size_option_button_item_selected(index):
  GlobalSettings.set_shadow_size(index)
  SaveSettings.game_settings["shadow_size"] = index


func _on_shadow_filter_option_button_item_selected(index):
  GlobalSettings.set_shadow_filter(index)
  SaveSettings.game_settings["shadow_filter"] = index


func _on_mesh_lod_option_button_item_selected(index):
  GlobalSettings.set_mesh_lod(index)
  SaveSettings.game_settings["mesh_lod"] = index

# Effect settings.

func _on_ss_reflections_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_ss_reflections(index)
  SaveSettings.game_settings["ss_reflections"] = index


func _on_ssao_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_ssao(index)
  SaveSettings.game_settings["ssao"] = index


func _on_ssil_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_ssil(index)
  SaveSettings.game_settings["ssil"] = index


func _on_sdfgi_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_sdfgi(index)
  SaveSettings.game_settings["sdfgi"] = index


func _on_glow_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_glow(index)
  SaveSettings.game_settings["glow"] = index


func _on_volumetric_fog_option_button_item_selected(index: int) -> void:
  GlobalSettings.set_volumetric_fog(index)
  SaveSettings.game_settings["volumetric_fog"] = index

# Quality presets.

func _on_very_low_preset_pressed() -> void:
  %FilterOptionButton.selected = 0
  %TAAOptionButton.selected = 0
  %MSAAOptionButton.selected = 0
  %FXAAOptionButton.selected = 0
  %ShadowSizeOptionButton.selected = 0
  %ShadowFilterOptionButton.selected = 0
  %MeshLODOptionButton.selected = 0
  %SDFGIOptionButton.selected = 0
  %GlowOptionButton.selected = 0
  %SSAOOptionButton.selected = 0
  %SSReflectionsOptionButton.selected = 0
  %SSILOptionButton.selected = 0
  %VolumetricFogOptionButton.selected = 0
  update_preset()

func _on_low_preset_pressed() -> void:
  %FilterOptionButton.selected = 1
  %TAAOptionButton.selected = 0
  %MSAAOptionButton.selected = 0
  %FXAAOptionButton.selected = 1
  %ShadowSizeOptionButton.selected = 1
  %ShadowFilterOptionButton.selected = 1
  %MeshLODOptionButton.selected = 1
  %SDFGIOptionButton.selected = 0
  %GlowOptionButton.selected = 0
  %SSAOOptionButton.selected = 0
  %SSReflectionsOptionButton.selected = 0
  %SSILOptionButton.selected = 0
  %VolumetricFogOptionButton.selected = 0
  update_preset()


func _on_medium_preset_pressed() -> void:
  %FilterOptionButton.selected = 1
  %TAAOptionButton.selected = 1
  %MSAAOptionButton.selected = 1
  %FXAAOptionButton.selected = 1
  %ShadowSizeOptionButton.selected = 2
  %ShadowFilterOptionButton.selected = 2
  %MeshLODOptionButton.selected = 2
  %SDFGIOptionButton.selected = 1
  %GlowOptionButton.selected = 1
  %SSAOOptionButton.selected = 1
  %SSReflectionsOptionButton.selected = 1
  %SSILOptionButton.selected = 0
  %VolumetricFogOptionButton.selected = 1
  update_preset()


func _on_high_preset_pressed() -> void:
  %FilterOptionButton.selected = 1
  %TAAOptionButton.selected = 1
  %MSAAOptionButton.selected = 2
  %FXAAOptionButton.selected = 1
  %ShadowSizeOptionButton.selected = 4
  %ShadowFilterOptionButton.selected = 4
  %MeshLODOptionButton.selected = 3
  %SDFGIOptionButton.selected = 2
  %GlowOptionButton.selected = 2
  %SSAOOptionButton.selected = 2
  %SSReflectionsOptionButton.selected = 2
  %SSILOptionButton.selected = 2
  %VolumetricFogOptionButton.selected = 2
  update_preset()


func _on_ultra_preset_pressed() -> void:
  %FilterOptionButton.selected = 1
  %TAAOptionButton.selected = 1
  %MSAAOptionButton.selected = 3
  %FXAAOptionButton.selected = 1
  %ShadowSizeOptionButton.selected = 5
  %ShadowFilterOptionButton.selected = 5
  %MeshLODOptionButton.selected = 3
  %SDFGIOptionButton.selected = 2
  %GlowOptionButton.selected = 2
  %SSAOOptionButton.selected = 4
  %SSReflectionsOptionButton.selected = 3
  %SSILOptionButton.selected = 3
  %VolumetricFogOptionButton.selected = 2
  update_preset()


func update_preset() -> void:
  # Simulate options being manually selected to run their respective update code.
  %FilterOptionButton.item_selected.emit(%FilterOptionButton.selected)
  %TAAOptionButton.item_selected.emit(%TAAOptionButton.selected)
  %MSAAOptionButton.item_selected.emit(%MSAAOptionButton.selected)
  %FXAAOptionButton.item_selected.emit(%FXAAOptionButton.selected)
  %ShadowSizeOptionButton.item_selected.emit(%ShadowSizeOptionButton.selected)
  %ShadowFilterOptionButton.item_selected.emit(%ShadowFilterOptionButton.selected)
  %MeshLODOptionButton.item_selected.emit(%MeshLODOptionButton.selected)
  %SDFGIOptionButton.item_selected.emit(%SDFGIOptionButton.selected)
  # %GlowOptionButton.item_selected.emit(%GlowOptionButton.selected)
  %SSAOOptionButton.item_selected.emit(%SSAOOptionButton.selected)
  %SSReflectionsOptionButton.item_selected.emit(%SSReflectionsOptionButton.selected)
  %SSILOptionButton.item_selected.emit(%SSILOptionButton.selected)
  # %VolumetricFogOptionButton.item_selected.emit(%VolumetricFogOptionButton.selected)
