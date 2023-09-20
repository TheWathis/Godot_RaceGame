class_name ActionEventItem extends PanelContainer


var action_event: String = ""
var input_key: String = ""

var _wait_for_input: bool = false


func _ready() -> void:
  %Action.text = action_event.capitalize()
  %Key.text = input_key


func _unhandled_key_input(event: InputEvent) -> void:
  if not _wait_for_input:
    return
  
  if not event is InputEventKey:
    return
  
  if event.is_action("ui_cancel"):
    %Key.text = input_key
    _wait_for_input = false
    return
  
  input_key = event.as_text_physical_keycode()
  _wait_for_input = false
  %Key.text = input_key
  InputMap.action_erase_events(action_event)
  InputMap.action_add_event(action_event, event)
  SaveSettings.save_actions_events()


func _on_key_pressed() -> void:
  %Key.text = "..."
  _wait_for_input = true