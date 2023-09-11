class_name FOVCamera extends Camera3D


func _ready() -> void:
  if not GlobalSettings.fov_updated.is_connected(_on_fov_updated):
    GlobalSettings.fov_updated.connect(_on_fov_updated)


func _on_fov_updated(new_fov: float) -> void:
  fov = new_fov