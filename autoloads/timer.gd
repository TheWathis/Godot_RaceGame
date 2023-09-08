extends Node

## Emitted every tick.
signal tick()

## Duration of a tick in seconds.
const TICK_INTERVAL: float = 0.05

## Number of ticks already elapsed.
var tick_count: int = 0
## Time elapsed since the start of the track.
var timer: float = 0.0

var _tick_timer: float = 0.0


func _ready() -> void:
  set_physics_process(false)


func _physics_process(delta: float) -> void:
  timer += delta

  _tick_timer += delta
  if _tick_timer >= TICK_INTERVAL:
    _tick_timer -= TICK_INTERVAL
    tick.emit()
    tick_count += 1


## Start the track timer.
func start() -> void:
  set_physics_process(true)


## Stop the track timer.
func stop() -> void:
  set_physics_process(false)


## Reset the track timer.
func reset() -> void:
  tick_count = 0
  timer = 0.0
  _tick_timer = 0.0
