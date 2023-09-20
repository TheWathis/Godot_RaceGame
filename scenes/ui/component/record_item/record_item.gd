class_name RecordItem extends PanelContainer


var map_seed: int = 0
var map_time: float = 0.0


func _ready() -> void:
  %Seed.text = str(map_seed)
  %Time.text = str(Utils.convert_float_timer_to_string(map_time))


func _on_button_pressed() -> void:
  Random.rng.set_seed(map_seed)
  var scene = load("res://main_race.tscn")
  get_tree().change_scene_to_packed(scene)
