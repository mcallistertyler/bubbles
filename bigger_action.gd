extends Node2D

@onready var mash_timer : Timer = get_node("%MashTimer")
@export var bubble_player_path : NodePath
@onready var bubble_player : Bubble = get_node(bubble_player_path)
@onready var death_rect : ColorRect = get_node("%DeathRect")
@onready var death_text : RichTextLabel = get_node("%DeathText")
@onready var points_label : RichTextLabel = get_node("%PointsLabel")
@onready var speed_label : RichTextLabel = get_node("%SpeedLabel")
@onready var background_music : AudioStreamPlayer = get_node("%BackgroundMusic")

func _ready() -> void:
	bubble_player.connect("is_dead", _player_dead)

func display_death_text() -> void:
	death_text.visible = true

func fade_to_black() -> void:
	var fade_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(false)
	fade_tween.tween_property(death_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 2.0)
	fade_tween.tween_callback(display_death_text)

func _player_dead() -> void:
	fade_to_black()
	background_music.stop()
	
func _process(delta: float) -> void:
	if speed_label.speed_value != Autoload.current_object_speed:
		speed_label.update_speed_value(Autoload.current_object_speed)
	if points_label.points_value != Autoload.current_points:
		points_label.update_points_value(Autoload.current_points)
