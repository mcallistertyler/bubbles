@tool
class_name SuckableObject
extends Node2D

@onready var center_point : Marker2D = get_node("%CenterPoint")
@onready var collision_shape : CollisionShape2D = get_node("%CollisionShape2D")
@onready var audio_stream_player : AudioStreamPlayer = get_node("%AudioStreamPlayer")
@export var radius : float = 80
@export var points : int = 10
@export var scale_sprite : Vector2 = Vector2.ZERO
@onready var sprite_2d : Sprite2D = get_node("%Sprite2D")
@export var sprite_path : Texture
var go_to_point = null
@export var current_speed : float = 400.0
@export var speed_multiplier : float = 1.0
@export var speed_increment : float = 0.05

func _ready() -> void:
	Autoload.connect("increase_speed", _increase_speed)

	if sprite_path != null:
		sprite_2d.texture = sprite_path
	if scale_sprite != Vector2.ZERO:
		sprite_2d.scale = scale_sprite
	collision_shape.shape.radius = radius
	
func play_death():
	audio_stream_player.play()

func _increase_speed():
	speed_multiplier += speed_increment

func get_center_point() -> Vector2:
	return center_point.global_position
	
func move_towards_point(go_to_point: Vector2) -> void:
	self.go_to_point = go_to_point

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if self.go_to_point != null:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", self.go_to_point, 0.3).set_ease(Tween.EASE_IN_OUT)
		else:
			self.global_position.y += current_speed * speed_multiplier * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	self.queue_free()
