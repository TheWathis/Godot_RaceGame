@tool
class_name Connector extends Node3D

@export var color: Color = Color(1, 1, 1, 1): set = _set_color
@export var connected: bool = false: set = _set_connected

@export_enum("bitumen", "grass") var type: String = "bitumen"
@export_range(-25, 25, 5, "hide_slider") var inclination: int = 0: set = _set_inclination

func _set_color(value: Color) -> void:
  color = value
  %MeshInstance3D.material_override.albedo_color = value


func _set_connected(value: bool) -> void:
  connected = value
  %MeshInstance3D.visible = !value


func _set_inclination(value: int) -> void:
  inclination = value
  rotation.z = value * PI / 180


## Returns true if the connector can be connected with the other connector
func can_be_connected_with(other: Connector) -> bool:
  var both_not_connected: bool = !connected && !other.connected
  var same_type: bool = type == other.type
  var same_inclination: bool = inclination == other.inclination
  return both_not_connected && same_type && same_inclination


func is_colliding_with_blocs() -> bool:
  return false
  # var bodies: Array[Node3D] = %Area3D.get_overlapping_bodies()
  # if bodies.size() == 0:
  #   return false
  
  # return true
