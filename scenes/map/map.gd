class_name Map extends Node3D


## List of blocs of the map in order.[br]
## The first bloc is the start bloc, the last is the end bloc.
var blocs: Array[Bloc] = []
## List of checkpoints of the map.
var checkpoints: Array[Checkpoint] = []

var _start_height: float = 0.0
var _start_scene: PackedScene = preload("res://scenes/blocs/flat/start/start.tscn")
var _checkpoint_scene: PackedScene = preload("res://scenes/blocs/flat/checkpoint/checkpoint.tscn")
var _end_scene: PackedScene = preload("res://scenes/blocs/flat/end/end.tscn")


func _ready() -> void:
  if not MapsInfo.maps_information.has(Random.rng.seed):
    MapsInfo.add_map(Random.rng.seed)


func _last_bloc_height() -> float:
  var height: float = _start_height
  for bloc in blocs:
    height += bloc.height_delta
  return height


## Check if the bloc can be added to the map.
func can_add_bloc(bloc: Bloc) -> bool:
  if _last_bloc_height() + bloc.height_delta < 0:
    return false
  
  # Check if the last connector can be connected to the bloc
  var last_bloc: Bloc = blocs[-1]
  var last_connector: Connector = last_bloc.get_empty_connectors()[0]
  var can_connect: bool = last_connector.can_be_connected_with(bloc.get_empty_connectors()[0])
  return can_connect


## Add a bloc to the map behind the last bloc.[br]
## Return true if the bloc was added, false otherwise.
func add_bloc(bloc: Bloc) -> bool:
  add_child(bloc)
  if bloc.connect_to(blocs[-1].get_empty_connectors()[0]):
    blocs.append(bloc)
    return true
  
  return false


## Get the start bloc of the map.
func get_start() -> Bloc:
  return blocs[0]


## Get the end bloc of the map.
func get_end() -> Bloc:
  return blocs[blocs.size() - 1]


## Get the empty connectors of the map.[br]
## Should always be the last bloc of the map.
func get_empty_connectors() -> Array[Connector]:
  var empty_connectors: Array[Connector] = []
  for bloc in blocs:
    for connector in bloc.get_empty_connectors():
      empty_connectors.append(connector)
  return empty_connectors


## Get the length of the road. (start and end blocs are not counted)
func get_road_length() -> int:
  return blocs.size() - 2


## Add a start bloc at the given position.
func add_start(world_position: Vector3) -> void:
  _start_height = world_position.y / 2.5
  var start: StartBloc = _start_scene.instantiate()
  add_child(start)
  start.global_position = world_position
  blocs.append(start)


## Add a checkpoint.
func add_checkpoint() -> void:
  var checkpoint: Checkpoint = _checkpoint_scene.instantiate()
  
  if not can_add_bloc(checkpoint):
    checkpoint.queue_free()
    return

  if add_bloc(checkpoint):
    checkpoints.append(checkpoint)
  else:
    checkpoint.queue_free()


## Add an end bloc at the given position.
func add_end() -> void:
  # Get the last connector roll
  var last_bloc: Bloc = blocs[-1]
  var last_connector: Connector = last_bloc.get_empty_connectors()[0]
  var roll: int = last_connector.roll

  var end: EndBloc = _end_scene.instantiate()
  add_bloc(end)
  end.map = self

  # Rotate the end bloc
  end.rotation.z = roll * PI / 180

  set_best_times()


## Set the saved best time for checkpoints and end bloc.
func set_best_times() -> void:
  var end: EndBloc = get_end()
  end.best_validation_time = MapsInfo.get_best_time(Random.rng.seed)
  # var best_checkpoints_time: Array[float] = MapsInfo.get_checkpoints_best_time(Random.rng.seed)
  var best_checkpoints_time: Array = MapsInfo.get_checkpoints_best_time(Random.rng.seed)
  if best_checkpoints_time.size() == checkpoints.size():
    for i in range(checkpoints.size()):
      checkpoints[i].best_checkpoint_time = best_checkpoints_time[i]


## Reset the state of the map.[br]
## i.e.: Invalidate all checkpoints.
func reset_map() -> void:
  # Check if it's pb
  var end: EndBloc = get_end()
  end.precedent_validation_time = end.validation_time
  end.validation_time = 0.0

  for checkpoint in checkpoints:
    checkpoint.validated = false
    checkpoint.precedent_checkpoint_time = checkpoint.checkpoint_time
    checkpoint.checkpoint_time = 0.0
  
  get_start().place_player(self)


## Update the best time for checkpoints
func update_checkpoints_best_time() -> void:
  for checkpoint in checkpoints:
    checkpoint.best_checkpoint_time = checkpoint.checkpoint_time


## Save map informations
func save_map_informations() -> void:
  var end: EndBloc = get_end()
  MapsInfo.set_best_time(Random.rng.seed, end.best_validation_time)
  var best_checkpoints_time: Array[float] = []
  for checkpoint in checkpoints:
    best_checkpoints_time.append(checkpoint.best_checkpoint_time)
  MapsInfo.set_checkpoints_best_time(Random.rng.seed, best_checkpoints_time)


## Check if the condition to win the map is met.
func is_end_available() -> bool:
  for checkpoint in checkpoints:
    if not checkpoint.validated:
      return false
  return true


## Get validated checkpoints.
func get_validated_checkpoints() -> Array[Checkpoint]:
  var validated_checkpoints: Array[Checkpoint] = []
  for checkpoint in checkpoints:
    if checkpoint.validated:
      validated_checkpoints.append(checkpoint)
  return validated_checkpoints


## Place the player at the start of the map.
func place_player() -> void:
  get_start().place_player(self)


## Clear the map.
func clear_map() -> void:
  for b in blocs:
    b.queue_free()
  blocs.clear()
  checkpoints.clear()
  _start_height = 0.0
