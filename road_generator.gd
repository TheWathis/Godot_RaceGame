class_name RoadGenerator extends Node3D

@export var roads: Array[PackedScene] = []
## Desired road length (25 blocs ~= 45 seconds)
@export var desired_road_length: int = 25

var map_scene: PackedScene = preload("res://scenes/map/map.tscn")
var map_node: Map

# Road length without checkpoint, used to not generate too many roads without checkpoint
var _road_length_without_checkpoint: int = 0


func _generate() -> void:
  if not MapsInfo.maps_information.has(Random.rng.seed):
    MapsInfo.add_map(Random.rng.seed)
  
  assert(roads.size() != 0, "No roads")
  
  var random_start_height: int = Random.rng.randi_range(0, 4)
  map_node.add_start(Vector3(0, random_start_height * 2.5, 0))

  var possible_blocs: Array[PackedScene] = roads.duplicate()
  
  while map_node.get_road_length() < desired_road_length \
    and map_node.get_empty_connectors().size() != 0 \
    and possible_blocs.size() != 0:
    # Should we add a checkpoint? (100% after 15 roads)
    var checkpoint_probability: float = _road_length_without_checkpoint / 15.0
    if Random.rng.randf_range(0.0, 1.0) < checkpoint_probability:
      # Add a checkpoint
      map_node.add_checkpoint()
      _road_length_without_checkpoint = 0
    
    await get_tree().create_timer(0.005).timeout

    # Add a road
    var road: PackedScene = possible_blocs[Random.rng.randi_range(0, possible_blocs.size() - 1)]
    var road_instance: Bloc = road.instantiate()

    if not map_node.can_add_bloc(road_instance):
      possible_blocs.erase(road)
      road_instance.queue_free()
      continue
    
    if map_node.add_bloc(road_instance):
      _road_length_without_checkpoint += 1
      possible_blocs = roads.duplicate()
    else:
      road_instance.queue_free()
      possible_blocs.erase(road)
      continue

  map_node.add_end()
  await get_tree().create_timer(0.005).timeout
  
  # print("Roads generated")
  %SpectatorCamera.current = false
  map_node.place_player()


func _clear() -> void:
  if map_node != null:
    # Clear the current map
    map_node.clear_map()
  else:
    # Add a new map
    map_node = map_scene.instantiate()
    add_child(map_node)
