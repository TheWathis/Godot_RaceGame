class_name Bloc extends Node3D


## Delta between the input and the output (-1 = go down one bloc, 0 = same level, 1 = go up one bloc)
@export var height_delta: int = 0

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

    var result: Array[Dictionary] = Physics.sphere_test(out_connector.global_position, 10)
    for r in result:
      if r.collider.owner.get_parent() == self:
        continue
      
      if r.collider.owner.get_parent() is Bloc:
        c.connected = false
        connector.connected = false
        return false

  return true
