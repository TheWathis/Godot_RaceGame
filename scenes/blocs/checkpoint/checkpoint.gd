class_name Checkpoint extends Bloc

var validated: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
  if body is Player:
    validated = true
    body.last_respawn_position = %PlayerPosition.global_position
    body.last_respawn_basis = %PlayerPosition.global_transform.basis
    body.display_checkpoint_time()
