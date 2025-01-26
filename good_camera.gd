extends Node2D

@export var phantom_camera_target : NodePath
@export var node_to_follow : NodePath
@onready var phantom_camera : PhantomCamera2D = get_node("%PhantomCamera2D")

@onready var host_camera : Camera2D = get_node("%Camera2D")

func _ready() -> void:
	if phantom_camera.follow_mode == 1 or phantom_camera.follow_mode == 5:
		phantom_camera.follow_target = get_node(phantom_camera_target)

func zoom_level(zoom_vector: Vector2, duration: float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	var current_zoom = phantom_camera.zoom
	tween.tween_property(phantom_camera, "zoom", zoom_vector, duration)
