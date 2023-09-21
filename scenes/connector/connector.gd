@tool
class_name Connector extends Node3D

@export var color: Color = Color(1, 1, 1, 1): set = _set_color
@export var connected: bool = false: set = _set_connected

@export_enum("bitumen", "grass") var type: String = "bitumen"
@export_range(-25, 25, 5) var roll: int = 0: set = _set_roll
@export_range(-25, 25, 5) var pitch: int = 0: set = _set_pitch
@export_range(5, 50, 1) var width: int = 20: set = _set_width

func _set_color(value: Color) -> void:
  color = value
  %MeshInstance3D.material_override.albedo_color = value


func _set_connected(value: bool) -> void:
  connected = value
  %MeshInstance3D.visible = !value


func _set_roll(value: int) -> void:
  roll = value
  rotation.z = value * PI / 180


func _set_pitch(value: int) -> void:
  pitch = value
  rotation.x = value * PI / 180


func _set_width(value: int) -> void:
  width = value
  %MeshInstance3D.mesh.size.x = value


## Returns true if the connector can be connected with the other connector
func can_be_connected_with(other: Connector) -> bool:
  var both_not_connected: bool = !connected && !other.connected
  var same_type: bool = type == other.type
  var same_roll: bool = roll == other.roll
  var same_pitch: bool = pitch == other.pitch
  var same_width: bool = width == other.width
  return both_not_connected && same_type && same_roll && same_pitch && same_width


func is_colliding_with_blocs() -> bool:
  return false
  # var bodies: Array[Node3D] = %Area3D.get_overlapping_bodies()
  # if bodies.size() == 0:
  #   return false
  
  # return true
