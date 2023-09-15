extends PanelContainer


func _ready() -> void:
  if MapsInfo.get_best_time(Random.rng.seed) < 0:
    %BestTime.get_parent().hide()
  
  %BestTime.text = Utils.convert_float_timer_to_string(MapsInfo.get_best_time(Random.rng.seed))
  %TimesPlayed.text = str(MapsInfo.get_times_played(Random.rng.seed))


func set_map_seed(map_seed: int) -> void:
  %Seed.text = str(map_seed)
