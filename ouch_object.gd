class_name OuchObject
extends Node2D

@export var moves_sideways : bool = false
@export var speed_increment : float = 0.05
@export var speed_multiplier: float = 1.0
@export var current_speed : float = 300.0

func _ready() -> void:
	Autoload.connect("increase_speed", _increase_speed)

func _increase_speed():
	speed_multiplier += speed_increment

func _physics_process(delta: float) -> void:
	if moves_sideways:
		pass
	self.global_position.y += current_speed * speed_multiplier * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
