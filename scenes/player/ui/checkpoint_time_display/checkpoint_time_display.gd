extends VBoxContainer


func set_current_checkpoint_time(time: float) -> void:
  %CurrentCheckpointTime.text = Utils.convert_float_timer_to_string(time)


func set_best_time_visibility(visibility: bool) -> void:
  %BestTimeDelta.visible = visibility


func set_best_time_delta(time: float) -> void:
  if time <= 0:
    %BestTimeDelta.modulate = Color(0, 1, 0)
  else:
    %BestTimeDelta.modulate = Color(1, 0, 0)
  
  var base: String = "-" if time <= 0 else "+"
  %BestTimeDelta.text = base + Utils.convert_float_timer_to_string(abs(time))


func set_precedent_time_delta(time: float) -> void:
  if time <= 0:
    %PrecedentTimeDelta.modulate = Color(0, 1, 0)
  else:
    %PrecedentTimeDelta.modulate = Color(1, 0, 0)
  
  var base: String = "-" if time <= 0 else "+"
  %PrecedentTimeDelta.text = base + Utils.convert_float_timer_to_string(abs(time))


func _on_visibility_changed() -> void:
  if not visible:
    return
  
  %Timer.start()


func _on_timer_timeout() -> void:
  hide()
