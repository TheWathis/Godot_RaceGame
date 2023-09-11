class_name Player extends VehicleBody3D

# Car related

const STEER_SPEED = 2.5
const STEER_LIMIT = 0.15

@export var engine_force_value: int = 40

var steer_target: float = 0.0

# Map related

var start_bloc: StartBloc

var last_respawn_position: Vector3 = Vector3(0, 0, 0)
var last_respawn_basis: Basis = Basis.IDENTITY

var save_inertia: Vector3 = Vector3.ZERO
var save_angular_velocity: Vector3 = Vector3.ZERO
var save_linear_velocity: Vector3 = Vector3.ZERO
var save_linear_damp: float = 0.0
var save_steering: float = 0.0

# Control related

var ended: bool = false
var paused: bool = false

@onready var fps_label: Label = %FPSLabel

func _ready() -> void:
  %Seed.text = str(Random.rng.seed)
  %Camera3D.current = true


func _process(_delta: float) -> void:
  %Timer.text = convert_timer_to_string()
  
  fps_label.text = "%d FPS (%.2f mspf)" % [Engine.get_frames_per_second(), 1000.0 / Engine.get_frames_per_second()]
  fps_label.modulate = fps_label.get_meta("Gradient").sample(remap(Engine.get_frames_per_second(), 0, 180, 0.0, 1.0))


func _physics_process(delta: float) -> void:
  var fwd_mps = (linear_velocity) * transform.basis.x

  if not ended and not paused:
    steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
    steer_target *= STEER_LIMIT

    if Input.is_action_pressed("accelerate"):
      # Increase engine force at low speeds to make the initial acceleration faster.
      var speed: float = linear_velocity.length()
      if speed < 5 and speed != 0:
        engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
      else:
        engine_force = engine_force_value
    else:
      engine_force = 0

    if Input.is_action_pressed("brake"):
      # Increase engine force at low speeds to make the initial acceleration faster.
      if fwd_mps.length() >= -1:
        var speed: float = linear_velocity.length()
        if speed < 5 and speed != 0:
          engine_force = -clamp(engine_force_value * 5 / speed, 0, 100)
        else:
          engine_force = -engine_force_value
      else:
        brake = 1.0
    else:
      brake = 0.0
  else:
    engine_force = 0
    brake = 1.0
  
  # Turn left
  if steer_target < 0:
    # Accelerate right wheels
    %Wheel_F_R.engine_force = engine_force / 2.0
    %Wheel_B_R.engine_force = engine_force / 2.0
    # Decelerate left wheels
    %Wheel_F_L.engine_force = engine_force / 4.0
    %Wheel_B_L.engine_force = engine_force / 4.0
  # Turn right
  elif steer_target > 0:
    # Accelerate left wheels
    %Wheel_F_L.engine_force = engine_force / 2.0
    %Wheel_B_L.engine_force = engine_force / 2.0
    # Decelerate right wheels
    %Wheel_F_R.engine_force = engine_force / 4.0
    %Wheel_B_R.engine_force = engine_force / 4.0
  # Go straight
  else:
    # Accelerate all wheels
    %Wheel_F_L.engine_force = engine_force / 2.0
    %Wheel_F_R.engine_force = engine_force / 2.0
    %Wheel_B_L.engine_force = engine_force / 2.0
    %Wheel_B_R.engine_force = engine_force / 2.0

  steering = move_toward(steering, steer_target, STEER_SPEED * delta)
  
  if %Wheel_F_L.get_skidinfo() < 0.3:
    %Wheel_F_L.get_node("DriftSmoke").emitting = true
  else:
    %Wheel_F_L.get_node("DriftSmoke").emitting = false
  if %Wheel_F_R.get_skidinfo() < 0.3:
    %Wheel_F_R.get_node("DriftSmoke").emitting = true
  else:
    %Wheel_F_R.get_node("DriftSmoke").emitting = false
  if %Wheel_B_L.get_skidinfo() < 0.3:
    %Wheel_B_L.get_node("DriftSmoke").emitting = true
  else:
    %Wheel_B_L.get_node("DriftSmoke").emitting = false
  if %Wheel_B_R.get_skidinfo() < 0.3:
    %Wheel_B_R.get_node("DriftSmoke").emitting = true
  else:
    %Wheel_B_R.get_node("DriftSmoke").emitting = false

  if not ended and not paused:
    if Input.is_action_just_pressed("ui_accept"):
      respawn_last_saved_position()
    
    if Input.is_action_just_pressed("restart_map"):
      restart_map()


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    GlobalTimer.stop()
    %EscapeScreen.show()
    save_inertia = inertia
    save_angular_velocity = angular_velocity
    save_linear_velocity = linear_velocity
    save_linear_damp = linear_damp
    save_steering = steering
    lock()


func resume() -> void:
  %EscapeScreen.hide()
  GlobalTimer.start()
  inertia = save_inertia
  angular_velocity = save_angular_velocity
  linear_velocity = save_linear_velocity
  linear_damp = save_linear_damp
  steering = save_steering
  unlock()


func display_checkpoint_time() -> void:
  %CheckpointTime.text = convert_timer_to_string()
  %CheckpointTime.show()
  %CheckpointTime.get_child(0).start()


func end_map() -> void:
  ended = true
  %EndTime.text = convert_timer_to_string()
  %NextSeed.text = str(Random.rng.seed)
  %EndScreen.show()


func restart_map() -> void:
  lock()
  GlobalTimer.reset()
  last_respawn_position = start_bloc.global_position
  last_respawn_basis = start_bloc.global_transform.basis
  respawn_last_saved_position()
  ended = false
  GlobalTimer.start()
  unlock()


func respawn_last_saved_position() -> void:
  set_physics_process(false)
  set_physics_process_internal(false)
  inertia = Vector3(0, 0, 0)
  angular_velocity = Vector3(0, 0, 0)
  linear_velocity = Vector3(0, 0, 0)
  linear_damp = 0.0
  steering = 0.0
  global_position = last_respawn_position
  global_transform.basis = last_respawn_basis
  set_physics_process_internal(true)
  set_physics_process(true)


func lock() -> void:
  axis_lock_angular_x = true
  axis_lock_angular_y = true
  axis_lock_angular_z = true
  axis_lock_linear_x = true
  axis_lock_linear_y = true
  axis_lock_linear_z = true
  paused = true


func unlock() -> void:
  axis_lock_angular_x = false
  axis_lock_angular_y = false
  axis_lock_angular_z = false
  axis_lock_linear_x = false
  axis_lock_linear_y = false
  axis_lock_linear_z = false
  paused = false


func convert_timer_to_string() -> String:
  var map_time: float = GlobalTimer.timer
  var ms: int = int(map_time * 1000)
  var s: int = int(map_time)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)

  if h == 0:
    return str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    return str(h % 24).pad_zeros(2) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)


func _on_timer_timeout() -> void:
  %CheckpointTime.hide()


func _on_home_button_pressed() -> void:
  var scene = load("res://home.tscn")
  get_tree().change_scene_to_packed(scene)
  queue_free()


func _on_next_button_pressed() -> void:
  GlobalTimer.reset()
  Random.rng.seed = int(%NextSeed.text)
  get_tree().root.get_node("MainRace").new_map()
  queue_free()


func _on_resume_pressed() -> void:
  resume()


func _on_next_pressed() -> void:
  GlobalTimer.reset()
  Random.rng.randomize()
  get_tree().root.get_node("MainRace").new_map()
  queue_free()


func _on_reset_pressed() -> void:
  %EndScreen.hide()
  %EscapeScreen.hide()
  restart_map()
