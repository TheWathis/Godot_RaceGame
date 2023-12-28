class_name Player extends VehicleBody3D

# Car related

const STEER_SPEED: float = 2.5
const STEER_LIMIT: float = 0.25
const MAX_GEAR: int = 6

@export var engine_force_value: int = 100

var steer_target: float = 0.0
var current_gear: int = 1

# Map related

var map: Map

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
  %MapInformation.set_map_seed(Random.rng.seed)
  # %Camera3D.current = true
  %CustomCamera.get_node("Camera3D").current = true
  %CheckpointCounter.set_total_checkpoint(map.checkpoints.size())
  MapsInfo.increment_played(Random.rng.seed)


func _process(_delta: float) -> void:
  %Timer.text = Utils.convert_float_timer_to_string(GlobalTimer.timer)
  
  fps_label.text = "%d FPS (%.2f mspf)" % [Engine.get_frames_per_second(), 1000.0 / Engine.get_frames_per_second()]
  fps_label.modulate = fps_label.get_meta("Gradient").sample(
    remap(Engine.get_frames_per_second(), 0, 180, 0.0, 1.0)
  )
  
  %Speed.text = "%d km/h" % [linear_velocity.length() * 3.6]
  %Gear.text = "%d" % [current_gear]


func _physics_process(delta: float) -> void:
  var forward_movement: Vector3 = linear_velocity * transform.basis.z

  $VelocityVisualizer.set("scale", Vector3(1, 1, linear_velocity.length() / 10.0))
  # Set the rotation of the velocity visualizer to be the linear velocity direction
  $VelocityVisualizer.set("rotation_degrees", Vector3(0, 0, atan2(linear_velocity.x, linear_velocity.z) * 180.0 / PI))


  # Revolution per minutes (it's wrong but w/e)
  var rpm: float = 0.0

  if not ended and not paused:
    steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
    # steer_target *= lerp(0.0, STEER_LIMIT, 1.0 / (1.0 + sqrt(linear_velocity.length())))
    steer_target *= STEER_LIMIT

    var is_in_air: bool = not %Wheel_F_L.is_in_contact() and not %Wheel_F_R.is_in_contact() \
      and not %Wheel_B_L.is_in_contact() and not %Wheel_B_R.is_in_contact()

    if Input.is_action_pressed("accelerate"):
      rpm = engine_force_value * current_gear
    else:
      rpm = 0

    if Input.is_action_pressed("brake"):
      if is_in_air:
        # If the car is in the air, stabilize it.
        angular_velocity = Vector3(0, 0, 0)
        
      if forward_movement.length() >= -1:
        rpm = -engine_force_value
      else:
        brake = engine_force_value / 4.0
    else:
      brake = 0.0
  else:
    rpm = 0
    brake = 0.0
  
  ## Camera
  var init_pos: Vector3 = %CustomCamera.get_node("Target").global_position
  var v_direction: Vector3 = linear_velocity.normalized()
  var dest_pos: Vector3 = global_position + linear_velocity.length() / 5.0 * v_direction
  %CustomCamera.get_node("Target").global_position = lerp(init_pos, dest_pos, 0.1)
  
  ## Vehicleforce
  # Turn left
  if steer_target < 0:
    # Accelerate right wheels
    %Wheel_F_R.engine_force = rpm / 1.0
    # %Wheel_B_R.engine_force = rpm / 3.0
    # Decelerate left wheels
    %Wheel_F_L.engine_force = rpm / 2.0
    # %Wheel_B_L.engine_force = rpm / 6.0
  # Turn right
  elif steer_target > 0:
    # Accelerate left wheels
    %Wheel_F_L.engine_force = rpm / 1.0
    # %Wheel_B_L.engine_force = rpm / 3.0
    # Decelerate right wheels
    %Wheel_F_R.engine_force = rpm / 2.0
    # %Wheel_B_R.engine_force = rpm / 6.0
  # Go straight
  else:
    # Accelerate all wheels
    %Wheel_F_L.engine_force = rpm / 2.0
    %Wheel_F_R.engine_force = rpm / 2.0
    # %Wheel_B_L.engine_force = rpm / 4.0
    # %Wheel_B_R.engine_force = rpm / 4.0
  
  ## Steering
  steering = move_toward(steering, steer_target, STEER_SPEED * delta)
  
  ## Effects
  if %Wheel_F_L.get_skidinfo() < 0.75:
    %Wheel_F_L.get_node("DriftSmoke").emitting = true
    %DriftTrail_F_L.emit = true
  else:
    %Wheel_F_L.get_node("DriftSmoke").emitting = false
    %DriftTrail_F_L.emit = false
  if %Wheel_F_R.get_skidinfo() < 0.75:
    %Wheel_F_R.get_node("DriftSmoke").emitting = true
    %DriftTrail_F_R.emit = true
  else:
    %Wheel_F_R.get_node("DriftSmoke").emitting = false
    %DriftTrail_F_R.emit = false
  if %Wheel_B_L.get_skidinfo() < 0.75:
    %Wheel_B_L.get_node("DriftSmoke").emitting = true
    %DriftTrail_B_L.emit = true
  else:
    %Wheel_B_L.get_node("DriftSmoke").emitting = false
    %DriftTrail_B_L.emit = false
  if %Wheel_B_R.get_skidinfo() < 0.75:
    %Wheel_B_R.get_node("DriftSmoke").emitting = true
    %DriftTrail_B_R.emit = true
  else:
    %Wheel_B_R.get_node("DriftSmoke").emitting = false
    %DriftTrail_B_R.emit = false
  
  ## Gear
  if rpm > 0:
    if linear_velocity.length() > 2.4 * MAX_GEAR * current_gear:
      current_gear = min(current_gear + 1, MAX_GEAR)
    elif linear_velocity.length() < 1.8 * current_gear:
      current_gear = max(current_gear - 1, 1)
  else:
    current_gear = max(current_gear - 1, 1)

  if not ended and not paused:
    if Input.is_action_just_pressed("restart_checkpoint"):
      respawn_last_saved_position()
    
    if Input.is_action_just_pressed("restart_map"):
      restart_map()


func _input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    GlobalTimer.stop()
    %EscapeScreen.show()
    # Can't use set_physics_process(false) nor set_physics_process(false) because it won't work
    save_inertia = inertia
    save_angular_velocity = angular_velocity
    save_linear_velocity = linear_velocity
    save_linear_damp = linear_damp
    save_steering = steering
    lock()


func resume() -> void:
  %EscapeScreen.hide()
  GlobalTimer.start()
  # Can't use set_physics_process(true) nor set_physics_process(true) because it won't work
  inertia = save_inertia
  angular_velocity = save_angular_velocity
  linear_velocity = save_linear_velocity
  linear_damp = save_linear_damp
  steering = save_steering
  unlock()


## Update the validated checkpoint display
func update_validated_checkpoint() -> void:
  %CheckpointCounter.set_validated_checkpoint(map.get_validated_checkpoints().size())


## Display the current checkpoint time
func display_checkpoint_time(
  cp_time: float,
  display_best_delta: bool,
  best_delta: float,
  _display_previous_delta: bool,
  previous_delta: float
) -> void:
  %CheckpointTime.set_current_checkpoint_time(cp_time)
  %CheckpointTime.set_best_time_visibility(display_best_delta)
  %CheckpointTime.set_best_time_delta(best_delta)
  %CheckpointTime.set_precedent_time_delta(previous_delta)
  %CheckpointTime.show()


## End the map for the player
func end_map(end_time: float, display_delta: bool, best_delta: float) -> void:
  ended = true
  %EndScreen.set_end_time(end_time)
  %EndScreen.set_delta_visibility(display_delta)
  %EndScreen.set_delta_time(best_delta)
  %EndScreen.show()


func restart_map() -> void:
  GlobalTimer.reset()
  map.reset_map()
  queue_free()


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
  # %Camera3D.position = Vector3(0, 4, 4)
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


func _on_home_button_pressed() -> void:
  var scene = load("res://home.tscn")
  get_tree().change_scene_to_packed(scene)
  queue_free()


func _on_resume_pressed() -> void:
  resume()


func _on_next_pressed() -> void:
  GlobalTimer.reset()
  Random.rng.randomize()
  get_tree().root.get_node("MainRace").new_map()
  queue_free()


func _on_reset_pressed() -> void:
  restart_map()
