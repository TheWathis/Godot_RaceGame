class_name Connector extends Node3D

@export var color: Color = Color(1, 1, 1, 1): set = _set_color
@export var connected: bool = false: set = _set_connected


func _set_color(value: Color) -> void:
  color = value
  %MeshInstance3D.material_override.albedo_color = value

func _set_connected(value: bool) -> void:
  connected = value
  %MeshInstance3D.visible = !value


func is_colliding_with_blocs() -> bool:
  return false
  # var bodies: Array[Node3D] = %Area3D.get_overlapping_bodies()
  # if bodies.size() == 0:
  #   return false
  
  # return true
