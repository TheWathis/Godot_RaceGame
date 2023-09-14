extends Control

@onready var player: Player = owner


func set_end_time(end_time: float) -> void:
  %EndTime.text = convert_float_timer_to_string(end_time)


func set_delta_time(delta: float) -> void:
  if delta <= 0:
    %DeltaTime.modulate = Color(0, 1, 0)
    %PersonalBest.show()
  else:
    %DeltaTime.modulate = Color(1, 0, 0)
    %PersonalBest.hide()
  
  var base: String = "-" if delta <= 0 else "+"
  %DeltaTime.text = base + convert_float_timer_to_string(abs(delta))


func set_next_seed(next_seed: int) -> void:
  %NextSeed.text = str(next_seed)


func convert_float_timer_to_string(timer: float) -> String:
  var ms: int = int(timer * 1000)
  var s: int = int(timer)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)

  if h == 0:
    return str(m % 60) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    return str(h % 24) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)


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
