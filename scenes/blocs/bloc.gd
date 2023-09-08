class_name Bloc extends Node3D


@export_enum("bitumen", "grass") var type: String = "bitumen": set = _set_type
## Delta between the input and the output (-1 = go down one bloc, 0 = same level, 1 = go up one bloc)
@export var height_delta: int = 0

var connectors: Array[Connector] = []


func _set_type(value: String) -> void:
  type = value
  match value:
    "bitumen":
      for connector in connectors:
        connector.color = Color(0.2, 0.2, 0.2)
    "grass":
      for connector in connectors:
        connector.color = Color(0.2, 0.8, 0.2)


func _enter_tree() -> void:
  for child in get_children():
    if child is Connector:
      connectors.append(child)


## Returns the position of all the connectors in the bloc
func get_empty_connectors() -> Array[Connector]:
  var c: Array[Connector] = []
  for connector in connectors:
    if not connector.connected:
      c.append(connector)
  return c


func connect_to(c: Connector) -> bool:
  # random connector
  var connector: Connector = connectors[0]
  # rotate the bloc so the connector is aligned with the connector_position
  global_transform.basis = c.global_transform.basis
  # move the bloc so the connector is on the connector_position
  global_position = c.global_position - connector.global_position
  
  c.connected = true
  connector.connected = true

  # Check if the road connectors collide with the other roads
  for out_connector in connectors:
    if out_connector.connected:
      continue

    var result: Array[Dictionary] = Physics.sphere_test(out_connector.global_position, 10)
    for r in result:
      if r.collider.owner.get_parent() == self:
        continue
      
      if r.collider.owner.get_parent() is Bloc:
        c.connected = false
        connector.connected = false
        return false

  return true
