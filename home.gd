extends Node3D


func _ready() -> void:
  %AudioStreamPlayer.volume_db = 0
  GlobalTimer.stop()
  GlobalTimer.reset()
  _on_generate_pressed()


func _on_generate_pressed() -> void:
  Random.rng.randomize()
  %Seed.text = str(Random.rng.seed)


func _on_play_pressed() -> void:
  Random.rng.set_seed(int(%Seed.text))
  var scene = load("res://main_race.tscn")
  get_tree().change_scene_to_packed(scene)


func _on_quit_pressed() -> void:
  get_tree().quit()


func _on_settings_pressed() -> void:
  %HomeMenu.hide()
  %SettingsContainer.show()


func _on_back_home_pressed() -> void:
  SaveSettings.save_data()
  %SettingsContainer.hide()
  %LeaderboardContainer.hide()
  %HomeMenu.show()


func _on_finished_map_pressed() -> void:
  %HomeMenu.hide()
  %LeaderboardContainer.show()
