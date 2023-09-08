class_name Player extends VehicleBody3D

const STEER_SPEED = 2.5
const STEER_LIMIT = 0.75

@export var engine_force_value = 40

var steer_target: float = 0.0

var last_respawn_position = Vector3(0, 0, 0)
var last_respawn_basis = Basis.IDENTITY


func _ready() -> void:
  %Seed.text = str(Random.rng.seed)


func _process(_delta: float) -> void:
  var map_time: float = GlobalTimer.timer
  var ms: int = int(map_time * 1000)
  var s: int = int(map_time)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)
  if h == 0:
    %Timer.text = str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    %Timer.text = str(h % 24).pad_zeros(2) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)


func _physics_process(delta: float) -> void:
  var fwd_mps = (linear_velocity) * transform.basis.x

  steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
  steer_target *= STEER_LIMIT

  if Input.is_action_pressed("ui_up"):
    # Increase engine force at low speeds to make the initial acceleration faster.
    var speed: float = linear_velocity.length()
    if speed < 5 and speed != 0:
      engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
    else:
      engine_force = engine_force_value
  else:
    engine_force = 0

  if Input.is_action_pressed("ui_down"):
    # Increase engine force at low speeds to make the initial acceleration faster.
    if fwd_mps.length() >= -1:
      var speed: float = linear_velocity.length()
      if speed < 5 and speed != 0:
        engine_force = -clamp(engine_force_value * 5 / speed, 0, 100)
      else:
        engine_force = -engine_force_value
    else:
      brake = 1
  else:
    brake = 0.0

  steering = move_toward(steering, steer_target, STEER_SPEED * delta)

  if Input.is_action_just_pressed("ui_accept"):
    inertia = Vector3(0, 0, 0)
    linear_velocity = Vector3(0, 0, 0)
    linear_damp = 0.0
    steering = 0.0
    global_position = last_respawn_position
    global_transform.basis = last_respawn_basis


func display_checkpoint_time() -> void:
  var map_time: float = GlobalTimer.timer
  var ms: int = int(map_time * 1000)
  var s: int = int(map_time)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)
  if h == 0:
    %CheckpointTime.text = str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    %CheckpointTime.text = str(h % 24).pad_zeros(2) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  %CheckpointTime.show()
  %CheckpointTime.get_child(0).start()


func _on_timer_timeout() -> void:
  %CheckpointTime.hide()
