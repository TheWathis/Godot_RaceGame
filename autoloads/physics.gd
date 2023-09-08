extends Node

@onready var global_world: World3D = get_tree().current_scene.get_world_3d()
@onready var space_state: PhysicsDirectSpaceState3D = global_world.direct_space_state

var sphere_query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
var ray_cast_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()

func _ready():
  sphere_query.shape = SphereShape3D.new()


# returns dictionary containing "position", "normal", "collider", "shape"
# returns empty dictionary if nothing hit.
func cast_ray(
  start: Vector3, end: Vector3, mask: int = 0x7FFFFFFF, ignore_objects: Array = []
) -> Dictionary:
  ray_cast_query.from = start
  ray_cast_query.to = end
  ray_cast_query.exclude = ignore_objects
  ray_cast_query.collision_mask = mask
  return space_state.intersect_ray(ray_cast_query)


# Returns array of dictionaries containing "rid", "collider_id", "collider", and "shape"
func sphere_test(
  position: Vector3, radius: float, mask: int = 0x7FFFFFFF, ignore_objects: Array = []
) -> Array[Dictionary]:
  sphere_query.collision_mask = mask
  sphere_query.exclude = ignore_objects
  sphere_query.shape.radius = radius
  sphere_query.transform = Transform3D(Basis(), position)
  return space_state.intersect_shape(sphere_query)