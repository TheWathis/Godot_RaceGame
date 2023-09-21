@tool
class_name Bloc extends Node3D


## Delta between the input and the output (-1 = go down one bloc, 0 = same level, 1 = go up one bloc)
@export var height_delta: int = 0


var _order_in_out_correct: bool = false
var _too_many_connectors: bool = false
var _area: Area3D = null


func _enter_tree() -> void:
  if not Engine.is_editor_hint:
    return
  
  # Code to execunte when in editor
  _update_warnings()

  if not child_order_changed.is_connected(_update_warnings):
    child_order_changed.connect(_update_warnings)


func _update_warnings(_node: Node = null) -> void:
  var connectors: Array[Connector] = get_connectors()
  
  if connectors.size() > 2:
    _too_many_connectors = true
  else:
    _too_many_connectors = false
  
  if connectors.size() == 2:
    if connectors[0].name.ends_with("IN") and connectors[1].name.ends_with("OUT"):
      _order_in_out_correct = true
    else:
      _order_in_out_correct = false
  else:
    _order_in_out_correct = false
  
  _area = get_node_or_null("Area3D")
  
  _get_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
  var warnings: PackedStringArray = []

  if not _order_in_out_correct:
    warnings.append("IN connector should be before OUT connector in the scene tree.")

  if _too_many_connectors:
    warnings.append("Too many connectors in the bloc. (max 2))")
  
  # if _area == null:
  #   warnings.append("No area found in the bloc.")

  # Returning an empty array means "no warning".
  return warnings


func get_connectors() -> Array[Connector]:
  var c: Array[Connector] = []
  for child in get_children():
    if child is Connector:
      c.append(child)
  return c


## Returns the position of all the connectors in the bloc
func get_empty_connectors() -> Array[Connector]:
  var c: Array[Connector] = []
  for connector in get_connectors():
    if not connector.connected:
      c.append(connector)
  return c


func connect_to(c: Connector) -> bool:
  # First connector
  var connector: Connector = get_connectors()[0]
  # Rotate the bloc so the connector is aligned with the connector_position
  global_transform.basis = c.global_transform.basis
  # Hack to fix the rotation (TODO: find a better way to do this)
  global_rotation.z -= c.rotation.z
  # Move the bloc so the connector is on the connector_position
  global_position = c.global_position - connector.global_position
  
  c.connected = true
  connector.connected = true

  # Check if the road connectors collide with the other roads
  for out_connector in get_connectors():
    if out_connector.connected:
      continue

    var result: Array[Dictionary] = Physics.sphere_test(out_connector.global_position, 20)
    for r in result:
      if r.collider.owner.get_parent() == self:
        continue
      
      if r.collider.owner.get_parent() is Bloc:
        c.connected = false
        connector.connected = false
        return false

  return true
