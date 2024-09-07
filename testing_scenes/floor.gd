@tool
extends MeshInstance3D

@export var amplitude: float = 0.1
@export var frequency: float = 10.0

@onready var default_position = Vector3(0, 0, 0)

var total_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  total_time = 0.0


  # Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
  total_time += delta
  # Add shaking effect to the floor
  var offset: float = sin(frequency * total_time) * amplitude
  global_position = default_position + Vector3(0, offset, 0)