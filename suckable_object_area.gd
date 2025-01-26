class_name SuckableArea2D
extends Area2D

@onready var collision_shape : CollisionShape2D = get_node("%CollisionShape2D")

func being_absorbed() -> void:
	#self.monitoring = false
	#self.monitorable = false
	#collision_shape.disabled = true
	pass
	
func get_suck_object() -> SuckableObject:
	return self.get_parent()
