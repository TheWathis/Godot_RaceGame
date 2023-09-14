class_name EndBloc extends Bloc


## Map reference. Usefull to check if the end is available.
var map: Map
## The total time for the validation.
var validation_time: float = 0.0
## The best time for the validation.
var best_validation_time: float = -1.0
## The precedent time for the validation.
var precedent_validation_time: float = 0.0


func _on_end_detector_body_entered(body: Node3D) -> void:
  if not body is Player:
    return
  
  if not map.is_end_available():
    return
  
  validation_time = GlobalTimer.timer
  Random.rng.randomize()
  body.end_map(validation_time)
  GlobalTimer.stop()
  GlobalTimer.reset()
