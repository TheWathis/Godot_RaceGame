class_name RoadGenerator extends Node3D

## Base path to the road blocs
const ROAD_BLOCS_PATH: String = "res://scenes/blocs/"


## Desired road length (25 blocs ~= 45 seconds)
@export var desired_road_length: int = 25


var map_scene: PackedScene = preload("res://scenes/map/map.tscn")
var map_node: Map


var _road_blocs: Array[PackedScene] = []
# Road length without checkpoint, used to not generate too many roads without checkpoint
var _road_length_without_checkpoint: int = 0


func _ready() -> void:
  _populate_blocs()


## Populate the blocs list
func _populate_blocs() -> void:
  var folder: DirAccess = DirAccess.open(ROAD_BLOCS_PATH)
  if not folder:
    print("An error occurred when trying to access the path.")
    return
  
  folder.list_dir_begin()
  _populate_blocs_from_folder(folder)


## Recursively populate the blocs list from the given folder
func _populate_blocs_from_folder(folder: DirAccess) -> void:
  var file: String = folder.get_next()
  while file != "":
    var current_dir: String = folder.get_current_dir() + "/"

    if file.begins_with("checkpoint") \
      or file.begins_with("end") \
      or file.begins_with("start") \
      or file == "." \
      or file == "..":
      file = folder.get_next()
      continue
    
    # It's a bloc: add it to the list
    if file.ends_with(".tscn"):
      _road_blocs.append(load(current_dir + file))
    
    # It's a folder: add all the blocs in it to the list
    elif folder.current_is_dir():
      var sub_folder: DirAccess = DirAccess.open(current_dir + file)
      sub_folder.list_dir_begin()
      _populate_blocs_from_folder(sub_folder)
      sub_folder.list_dir_end()
    file = folder.get_next()


func _generate() -> void:
  if not MapsInfo.maps_information.has(Random.rng.seed):
    MapsInfo.add_map(Random.rng.seed)
  
  assert(_road_blocs.size() != 0, "No roads")
  
  var random_start_height: int = Random.rng.randi_range(0, 4)
  map_node.add_start(Vector3(0, random_start_height * 2.5, 0))

  var possible_blocs: Array[PackedScene] = _road_blocs.duplicate()
  
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
      possible_blocs = _road_blocs.duplicate()
    else:
      road_instance.queue_free()
      possible_blocs.erase(road)
      continue

  map_node.add_end()
  await get_tree().create_timer(0.005).timeout
  
  # print("Roads generated")
  # %SpectatorCamera.current = false
  map_node.place_player()


func _clear() -> void:
  if map_node != null:
    # Clear the current map
    map_node.clear_map()
  else:
    # Add a new map
    map_node = map_scene.instantiate()
    add_child(map_node)
