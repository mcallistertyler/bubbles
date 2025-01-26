class_name Bubble
extends CharacterBody2D

@onready var bubble_sprite : Sprite2D = get_node("%BubbleSprite")
@onready var suck_area : Area2D = get_node("%SuckArea")
@onready var body_collision : CollisionShape2D = get_node("%BodyCollision")
@onready var suck_collision : CollisionShape2D = get_node("%SuckCollision")
@onready var bubble_center : Marker2D = get_node("%BubbleCenter")
@onready var blow_up_timer : Timer = get_node("%BlowUpTimer")
@onready var go_label : RichTextLabel = get_node("%GoLabel")
@onready var what_to_do_label : RichTextLabel = get_node("%WhatToDoLabel")
var movement_vector : Vector2 = Vector2.ZERO

@export var initial_blow_up_power : float = 0.25
var blow_up_power = initial_blow_up_power
var mash_blow_count : int = 0
var decay_rate : float = 0.8
var absorb_ratio : float = 0.20
@export var absorb_size_increase : float = 0.1
@export var absorb_size_decrease : float = 0.15
@onready var max_speed : float = 1000.0
@onready var acceleration : float = 50.0
@onready var deceleration : float = 150.0

var current_speed : float = 1900.0
var forward_speed : float = 150.0
var direction : float = 1.0
var last_press_time : float = 0.0
var button_mash_window : float = 0.2
var current_tween: Tween = null  # Add this as a class variable
var speed_multiplier : float = 1.0
var he_dead : bool = false

var absorbed_objects : Array[SuckableObject] = []
var timer_started : bool = false
@onready var blow_up_over : bool = true
var killed_go_label : bool = false
var killed_to_do_label : bool = false
signal is_dead

func _ready() -> void:
	bubble_sprite.scale = Vector2(0.5, 0.5)
	body_collision.scale = Vector2(0.5, 0.5)
	suck_collision.scale = Vector2(0.5, 0.5)
	blow_up_timer.connect("timeout", _blow_up_timer_timeout)
	go_label.visible = false
	what_to_do_label.visible = false
	
func _blow_up_timer_timeout() -> void:
	blow_up_over = true

func absorbed_stuff() -> void:
	for absorbed_object in absorbed_objects:
		if is_instance_valid(absorbed_object):
			if absorbed_object.scale != Vector2(0.2, 0.2):
				var absorb_tween = get_tree().create_tween().set_parallel(true)
				absorb_tween.tween_property(absorbed_object, "scale", Vector2(0.2, 0.2), 0.3)
			absorbed_object.move_towards_point(bubble_center.global_position)

func kill_go_label() -> void:
	killed_go_label = true
	if is_instance_valid(killed_go_label):
		go_label.queue_free()

func kill_what_to_do_label() -> void:
	killed_to_do_label = true
	if is_instance_valid(what_to_do_label):
		what_to_do_label.queue_free()

func _physics_process(delta: float) -> void:
	if bubble_sprite.scale.x <= 0.1 and !he_dead:
		time_to_die()
	if blow_up_over and !he_dead:
		if !killed_to_do_label:
			var text_tween = get_tree().create_tween()
			text_tween.tween_property(what_to_do_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 5.0)
			text_tween.tween_callback(kill_what_to_do_label)
		var input_direction = Input.get_axis("ui_left", "ui_right")
		var vertical_input_direction = Input.get_axis("ui_up", "ui_down")
		var acceleration = current_speed * speed_multiplier
		velocity.x = move_toward(velocity.x, input_direction * current_speed * speed_multiplier, acceleration)
		#velocity.y = move_toward(velocity.y, (vertical_input_direction) * 600.0, 600.0 * 0.3)
		move_and_slide()

		absorbed_stuff()


func time_to_die() -> void:
	bubble_sprite.visible = false
	suck_area.set_deferred("monitoring", false)
	suck_area.set_deferred("monitorable", false)
	body_collision.set_deferred("disabled", true)
	he_dead = true
	emit_signal("is_dead")

func increase_bubble_size_and_speed() -> void:
	if speed_multiplier <= 0.5:
		speed_multiplier += 0.1
	Autoload.speed_up()

func _on_suck_area_area_entered(area: Area2D) -> void:
	if area is SuckableArea2D:
		for collision in area.get_children():
			if collision is CollisionShape2D:
				if collision.shape.radius < (suck_collision.shape.radius * (1 - absorb_ratio)):
					var suck_object = area.get_suck_object()
					if !absorbed_objects.has(suck_object):
						suck_object.play_death()
						Autoload.increase_points(suck_object.points)
						absorbed_objects.push_back(suck_object)
						current_tween = get_tree().create_tween().set_parallel(true)
						current_tween.tween_property(bubble_sprite, "scale", Vector2(bubble_sprite.scale.x + absorb_size_increase, bubble_sprite.scale.y + absorb_size_increase), 0.05).set_ease(Tween.EASE_IN_OUT)
						current_tween.tween_property(body_collision, "scale", Vector2(body_collision.scale.x + absorb_size_increase, body_collision.scale.y + absorb_size_increase), 0.05).set_ease(Tween.EASE_IN_OUT)
						current_tween.tween_property(suck_collision, "scale", Vector2(suck_collision.scale.x + absorb_size_increase, suck_collision.scale.y + absorb_size_increase), 0.05).set_ease(Tween.EASE_IN_OUT)
						increase_bubble_size_and_speed()
	if area is OuchArea2D:
		current_tween = get_tree().create_tween().set_parallel(true)
		current_tween.tween_property(bubble_sprite, "scale", Vector2(bubble_sprite.scale.x - absorb_size_decrease, bubble_sprite.scale.y - absorb_size_decrease), 0.05).set_ease(Tween.EASE_IN_OUT)
		current_tween.tween_property(body_collision, "scale", Vector2(body_collision.scale.x - absorb_size_decrease, body_collision.scale.y - absorb_size_decrease), 0.05).set_ease(Tween.EASE_IN_OUT)
		current_tween.tween_property(suck_collision, "scale", Vector2(suck_collision.scale.x - absorb_size_decrease, suck_collision.scale.y - absorb_size_decrease), 0.05).set_ease(Tween.EASE_IN_OUT)
