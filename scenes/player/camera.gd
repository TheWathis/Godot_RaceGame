@tool
extends FOVCamera

@export var target: NodePath = NodePath(".."):
  set(value):
    _target = get_node(value)

## Minimum distance from the aim_pos.
@export var min_distance = 2.0
## Maximum distance from the aim_pos.
@export var max_distance = 6.0
@export var angle_v_adjust = 0.0
## Height of the camera.
@export var height = 1.5


var collision_exception: Array[RID] = []
var _previous_aim_pos: Vector3 = Vector3.ZERO


@onready var _target: Node3D = get_node(target)


func _ready() -> void:
  # Find collision exceptions for ray.
  var node = self
  while node:
    if node is RigidBody3D:
      collision_exception.append(node.get_rid())
      break
    else:
      node = node.get_parent()
  
  # This detaches the camera transform from the parent spatial node.
  set_as_top_level(true)


func _process(delta: float) -> void:
  var target_pos: Vector3 = get_node("../Target").global_position + Vector3(0, 0.5, 0)
  var root_pos: Vector3 = get_parent().global_position + Vector3(0, 0.5, 0)
  var new_pos: Vector3 = global_position
  var from_target: Vector3 = new_pos - root_pos

  # Check ranges.
  if from_target.length() < min_distance:
    from_target = from_target.normalized() * min_distance
  elif from_target.length() > max_distance:
    from_target = from_target.normalized() * max_distance

  from_target.y = height

  new_pos = root_pos + from_target

  var lerped_pos: Vector3 = lerp(global_position, new_pos, delta * 10.0)
  var lerped_aim_pos: Vector3 = lerp(_previous_aim_pos, target_pos, delta * 10.0)
  _previous_aim_pos = lerped_aim_pos
  look_at_from_position(lerped_pos, lerped_aim_pos, Vector3.UP)
