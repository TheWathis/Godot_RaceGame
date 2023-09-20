extends Control


var _record_item_scene: PackedScene = preload(
  "res://scenes/ui/component/record_item/record_item.tscn"
)


func _ready() -> void:
  var map_seeds: Array = MapsInfo.maps_information.keys()
  map_seeds.sort()

  for map_seed in map_seeds:
    var best_time: float = MapsInfo.get_best_time(map_seed)
    if best_time < 0:
      continue
    
    var record_item: RecordItem = _record_item_scene.instantiate()
    record_item.map_seed = map_seed
    record_item.map_time = best_time
    %RecordItemContainer.add_child(record_item)
