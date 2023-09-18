extends Control

@onready var player: Player = owner


func _ready() -> void:
  var save_seed: int = Random.rng.seed
  Random.rng.randomize()
  var next_seed: int = Random.rng.seed
  Random.rng.seed = save_seed
  %NextSeed.text = str(next_seed)


func set_end_time(end_time: float) -> void:
  %EndTime.text = Utils.convert_float_timer_to_string(end_time)


func set_delta_visibility(visibility: bool) -> void:
  %DeltaTime.visible = visibility


func set_delta_time(delta: float) -> void:
  if delta <= 0:
    %DeltaTime.modulate = Color(0, 1, 0)
    %PersonalBest.show()
  else:
    %DeltaTime.modulate = Color(1, 0, 0)
    %PersonalBest.hide()
  
  var base: String = "-" if delta <= 0 else "+"
  %DeltaTime.text = base + Utils.convert_float_timer_to_string(abs(delta))


func _on_improve_button_pressed() -> void:
  player.restart_map()


func _on_home_button_pressed() -> void:
  var scene = load("res://home.tscn")
  get_tree().change_scene_to_packed(scene)
  player.queue_free()


func _on_next_button_pressed() -> void:
  GlobalTimer.reset()
  Random.rng.seed = int(%NextSeed.text)
  get_tree().root.get_node("MainRace").new_map()
  player.queue_free()
