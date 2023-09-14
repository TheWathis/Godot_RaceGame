class_name EndBloc extends Bloc


## Map reference. Usefull to check if the end is available.
var map: Map
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
  
  var player: Player = body

  validation_time = GlobalTimer.timer

  Random.rng.randomize()
  GlobalTimer.stop()
  GlobalTimer.reset()

  var best_time_delta: float = validation_time - best_validation_time if best_validation_time >= 0.0 else 0.0
  player.end_map(validation_time, best_time_delta)

