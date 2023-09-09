class_name RoadGenerator extends Node3D

@export var generate: bool = false: set = _generate
@export var clear: bool = false: set = _clear
@export var roads: Array[PackedScene] = []
@export var road_length: int = 10


var start: PackedScene = preload("res://scenes/blocs/start/start.tscn")
var checkpoint: PackedScene = preload("res://scenes/blocs/checkpoint/checkpoint.tscn")
var end: PackedScene = preload("res://scenes/blocs/end/end.tscn")

# var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _current_road_length: int = 0
# Current road height, used to not generate roads below the ground
var _current_road_height: int = 0

func _generate(_value: bool = true) -> void:
  _clear()
  # rng.randomize()
  if roads.size() == 0:
    print("No roads")
    return
  
  var start_bloc: Bloc = start.instantiate()
  add_child(start_bloc)
  var random_start_height: int = Random.rng.randi_range(0, 4)
  start_bloc.global_position.y = random_start_height * 2.5
  _current_road_height = random_start_height

  var empty_connectors: Array[Connector] = start_bloc.get_empty_connectors()
  var possible_blocs: Array[PackedScene] = roads.duplicate()
  while empty_connectors.size() != 0 and possible_blocs.size() != 0:
    var connector = empty_connectors[0]
    await get_tree().create_timer(0.005).timeout
    # Add a road
    var road: PackedScene = possible_blocs[Random.rng.randi_range(0, possible_blocs.size() - 1)]
    # var road: PackedScene = possible_blocs[rng.randi_range(0, possible_blocs.size() - 1)]
    var road_instance: Bloc = road.instantiate()

    if _current_road_height + road_instance.height_delta >= 0:
      _current_road_height += road_instance.height_delta
      # print("Road height ok (" + str(_current_road_height) + ") with " + str(road_instance))
    else:
      # print("Road too low with " + str(road_instance))
      possible_blocs.erase(road)
      continue
    
    add_child(road_instance)

    if road_instance.connect_to(connector):
      _current_road_length += 1
      possible_blocs = roads.duplicate()
    else:
      # print("Can't connect " + str(road_instance))
      road_instance.queue_free()
      possible_blocs.erase(road)
      continue
    
    # Remove the connector
    empty_connectors.erase(connector)
    # Add the new empty connectors
    var new_empty_connectors: Array[Connector] = road_instance.get_empty_connectors()
    for new_connector_position in new_empty_connectors:
      empty_connectors.append(new_connector_position)
    # Check if the road is long enough
    if _current_road_length >= road_length:
      break

  for connector in empty_connectors:
    var end_bloc: Bloc = end.instantiate()
    add_child(end_bloc)
    end_bloc.connect_to(connector)
    await get_tree().create_timer(0.005).timeout
  
  # print("Roads generated")
  # print("Road length: " + str(_current_road_length))
  # print("Road height: " + str(_current_road_height))
  %SpectatorCamera.current = false
  start_bloc.place_player()


func _clear(_value: bool = true) -> void:
  _current_road_length = 0
  _current_road_height = 0
  for child in get_children():
    child.queue_free()
