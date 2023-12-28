class_name StartBloc extends Bloc


var player_scene: PackedScene = preload("res://scenes/player/KCC_Car.tscn")
# var player_scene: PackedScene = preload("res://scenes/player/player.tscn")


func place_player(map: Map) -> void:
  var player: KCC_Car = player_scene.instantiate()
  # player.map = map
  get_tree().root.add_child(player)
  # print("Player added to scene tree")
  player.global_position = %PlayerPosition.global_position
  # player.last_respawn_position = %PlayerPosition.global_position
  # player.last_respawn_basis = %PlayerPosition.global_transform.basis
  GlobalTimer.start()
