class_name EndBloc extends Bloc


## Map reference. Usefull to check if the end is available.
var map: Map

## Whether the player has validated the end.
var validated: bool = false
## The total time for the validation.
var validation_time: float = 0.0
## The best time for the validation.
var best_validation_time: float = -1.0
## The precedent time for the validation.
var precedent_validation_time: float = -1.0


func _on_end_detector_body_entered(body: Node3D) -> void:
  if not body is Player:
    return
  
  if not map.is_end_available():
    return
  
  var was_first_try: bool = best_validation_time < 0.0

  var player: Player = body

  validated = true
  validation_time = GlobalTimer.timer
  var best_time_delta: float = validation_time - best_validation_time
  
  if was_first_try or validation_time < best_validation_time:
    best_validation_time = validation_time
    map.update_checkpoints_best_time()
  
  GlobalTimer.stop()
  GlobalTimer.reset()
  
  player.end_map(validation_time, not was_first_try, best_time_delta)
  map.save_map_informations()
