class_name Checkpoint extends Bloc


## Whether the player has validated this checkpoint.
var validated: bool = false
## The time at which the player validated this checkpoint.
var checkpoint_time: float = 0.0
## The time at which the player validated this checkpoint with the best time.
var best_checkpoint_time: float = -1.0
## The time at which the player precedently validated this checkpoint.
var precedent_checkpoint_time: float = -1.0


func _on_area_3d_body_entered(body: Node3D) -> void:
  if not body is Player:
    return
  
  if validated:
    return
  
  var was_first_try: bool = best_checkpoint_time < 0.0

  var player: Player = body
  validated = true
  checkpoint_time = GlobalTimer.timer
  player.last_respawn_position = %PlayerPosition.global_position
  player.last_respawn_basis = %PlayerPosition.global_transform.basis
  player.update_validated_checkpoint()
  
  var precedent_time_delta: float = checkpoint_time - precedent_checkpoint_time if precedent_checkpoint_time >= 0.0 else 0.0
  var best_time_delta: float = checkpoint_time - best_checkpoint_time if best_checkpoint_time >= 0.0 else 0.0
  
  player.display_checkpoint_time(
    checkpoint_time,
    not was_first_try,
    best_time_delta,
    false,
    precedent_time_delta
  )
