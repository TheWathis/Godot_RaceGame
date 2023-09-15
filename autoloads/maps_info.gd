extends Node

const MAPS_INFO_FILE: String = "user://maps_info.ini"
const DEFAULT_INFORMATION: Dictionary = {
  # MapSeed: {
  #   "best_time": <best_time_float>,
  #   "times_played": <times_played_int>,
  #   "checkpoints": [
  #     <checkpoint_1_position_float>,
  #     <checkpoint_2_position_float>,
  #     ...
  #   ]
  # }
}


var maps_information: Dictionary = DEFAULT_INFORMATION.duplicate(true)


func _ready() -> void:
  load_data()


## Load the informations from the information file
func load_data() -> void:
  if not FileAccess.file_exists(MAPS_INFO_FILE):
    save_data()
  else:
    var file: FileAccess = FileAccess.open(MAPS_INFO_FILE, FileAccess.READ)
    maps_information.merge(file.get_var(), true)
    file.close()


## Save the current informations to the information file
func save_data() -> void:
  var file: FileAccess = FileAccess.open(MAPS_INFO_FILE, FileAccess.WRITE)
  file.store_var(maps_information)
  file.close()


## Add a new map to the information file
func add_map(map_seed: int) -> void:
  maps_information[map_seed] = {
    "best_time": -1.0,
    "times_played": 0,
    "checkpoints": []
  }
  save_data()


## Increment the number of times a map has been played
func increment_played(map_seed: int) -> void:
  maps_information[map_seed]["times_played"] += 1
  save_data()


## Return the number of times a map has been played
func get_times_played(map_seed: int) -> int:
  return maps_information[map_seed]["times_played"]


## Set the best time of a given map
func set_best_time(map_seed: int, best_time: float) -> void:
  maps_information[map_seed]["best_time"] = best_time
  save_data()


## Set the best time of a checkpoint list of a given map
func set_checkpoints_best_time(map_seed: int, checkpoints_time: Array[float]) -> void:
  maps_information[map_seed]["checkpoints"] = checkpoints_time
  save_data()


## Return the best time of a checkpoint list of a given map
# func get_checkpoints_best_time(map_seed: int) -> Array[float]:
func get_checkpoints_best_time(map_seed: int) -> Array:
  return maps_information[map_seed]["checkpoints"]


## Return the best time of a given map
func get_best_time(map_seed: int) -> float:
  return maps_information[map_seed]["best_time"]
