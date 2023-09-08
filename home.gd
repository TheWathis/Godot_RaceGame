extends Node3D


func _ready() -> void:
  _on_generate_pressed()

func _on_generate_pressed() -> void:
  Random.rng.randomize()
  %Seed.text = str(Random.rng.seed)


func _on_seed_text_changed() -> void:
  Random.rng.set_seed(int(%Seed.text))


func _on_play_pressed():
  var scene = load("res://main_race.tscn")
  get_tree().change_scene_to_packed(scene)
