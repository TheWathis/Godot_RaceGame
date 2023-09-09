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
