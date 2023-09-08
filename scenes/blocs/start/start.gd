extends Bloc


var player_scene: PackedScene = preload("res://scenes/player/player.tscn")


func _ready() -> void:
  var player: Player = player_scene.instantiate()
  get_tree().root.add_child.call_deferred(player)
  print("Player added to scene tree")
  player.global_position = %PlayerPosition.global_position
  player.last_respawn_position = %PlayerPosition.global_position
  player.last_respawn_basis = %PlayerPosition.global_transform.basis
  GlobalTimer.start()
