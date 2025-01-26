extends Node


var speed_cap : float = 300.0
var current_object_speed : float = 300.0

var current_speed_multiplier : float = 0.0

var current_points : int = 0

@export var speed_increment : float = 0.25
signal increase_speed

func set_current_object_speed(new_speed: float) -> void:
	current_object_speed = new_speed

func set_current_speed_multiplier(new_speed_multiplier: float) -> void:
	current_speed_multiplier = new_speed_multiplier

func get_current_speed_multiplier() -> float:
	return current_speed_multiplier

func get_current_object_speed() -> float:
	return current_object_speed
	
func speed_up() -> void:
	current_object_speed = clampf(current_object_speed * 1.1, 300.0, speed_cap)
	emit_signal("increase_speed")
	
func increase_points(increase: int) -> void:
	current_points += increase
	
func get_current_points() -> int:
	return current_points
