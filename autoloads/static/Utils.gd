class_name Utils


static func convert_float_timer_to_string(timer: float) -> String:
  var ms: int = int(timer * 1000)
  var s: int = int(timer)
  var m: int = int(s / 60.0)
  var h: int = int(m / 60.0)

  if h == 0:
    return str(m % 60) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)
  else:
    return str(h % 24) + ":" + str(m % 60).pad_zeros(2) + ":" + str(s % 60).pad_zeros(2) + ":" + str(ms % 1000).pad_zeros(3)