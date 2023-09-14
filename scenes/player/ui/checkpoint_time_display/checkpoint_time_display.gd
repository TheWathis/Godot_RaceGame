extends VBoxContainer


func set_current_checkpoint_time(time: float) -> void:
  %CurrentCheckpointTime.text = convert_float_timer_to_string(time)


func set_best_time_delta(time: float) -> void:
  if time <= 0:
    %BestTimeDelta.modulate = Color(0, 1, 0)
  else:
    %BestTimeDelta.modulate = Color(1, 0, 0)
  
  var base: String = "-" if time <= 0 else "+"
  %BestTimeDelta.text = base + convert_float_timer_to_string(abs(time))


func set_precedent_time_delta(time: float) -> void:
  if time <= 0:
    %PrecedentTimeDelta.modulate = Color(0, 1, 0)
  else:
    %PrecedentTimeDelta.modulate = Color(1, 0, 0)
  
  var base: String = "-" if time <= 0 else "+"
  %PrecedentTimeDelta.text = base + convert_float_timer_to_string(abs(time))


func convert_float_timer_to_string(timer: float) -> String:
  var ms: int = int(timer * 1000)
  var s: int = int(timer)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)

  if h == 0:
    return str(m % 60) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    return str(h % 24) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)


func _on_visibility_changed() -> void:
  if not visible:
    return
  
  %Timer.start()


func _on_timer_timeout() -> void:
  hide()
