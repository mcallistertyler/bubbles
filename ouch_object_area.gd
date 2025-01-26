class_name OuchArea2D
extends Area2D

@onready var collision_shape : CollisionShape2D = get_node("%CollisionShape2D")
@export var parent_node : NodePath

func being_absorbed() -> void:
	#self.monitoring = false
	#self.monitorable = false
	#collision_shape.disabled = true
	pass
	
func get_suck_object() -> OuchObject:
	var node_parent = get_node(parent_node)
	return node_parent
