extends Node

@export var possible_suckable_nodes : Array[PackedScene]
@export var possible_ouch_nodes : PackedScene
@export var spawn_marker_path_start : NodePath
@export var spawn_marker_path_end : NodePath
@export var gameplay_area_path : NodePath

@onready var spawn_marker_start : Marker2D = get_node(spawn_marker_path_start)
@onready var spawn_marker_end : Marker2D = get_node(spawn_marker_path_end)
@onready var gameplay_area : CanvasLayer = get_node(gameplay_area_path)

@onready var spawn_timer : Timer = get_node("%SpawnTimer")
@export var spawn_number_suckables : int = 5
@export var spawn_number_ouchables : int = 3

var speed_increased_counter :int = 0
var number_of_spawn_rows : int = 1
var max_number_of_spawn_rows : int = 10
var previous_suckable_position : Vector2 = Vector2.ZERO
var previous_ouchable_position : Vector2 = Vector2.ZERO
var x_distancer : float = 50.0
var object_speed : float = 100.0

func _ready() -> void:
	randomize()
	object_speed = Autoload.get_current_object_speed()
	_on_spawn_timer_timeout()
	Autoload.connect("increase_speed", _on_increase_speed)
	
func _on_increase_speed():
	speed_increased_counter += 1
	if speed_increased_counter % 5 == 0:
		number_of_spawn_rows += 1
		number_of_spawn_rows = clamp(number_of_spawn_rows, 1, max_number_of_spawn_rows)
		spawn_number_ouchables = randi_range(3, 7)
		if spawn_number_ouchables >= 6:
			spawn_number_suckables = randi_range(1, 3)
		else:
			spawn_number_suckables = randi_range(3, 6)
		#if spawn_number_ouchables <= 7:
			#spawn_number_ouchables += 1
		#if spawn_number_suckables <= 3:
			#spawn_number_suckables -= 1
func spawn_objects(previous_position: Vector2, y_offset: float = 0.0) -> Vector2:
	var start_y_position = spawn_marker_start.global_position.y + y_offset
	var random_position = Vector2(randf_range(spawn_marker_start.global_position.x - x_distancer, spawn_marker_end.global_position.x - x_distancer), start_y_position)
	if abs(random_position.x - previous_position.x) <= x_distancer:
		print("bro is too close")
		random_position.x += 200.0
	return random_position
	
func _on_spawn_timer_timeout() -> void:
	object_speed = Autoload.get_current_object_speed()
	var y_offset : float = 0.0
	# maybe dont do multiple rows
	for i in range(1):
		if i > 0:
			y_offset -= 500.0
		for j in range(spawn_number_suckables):
			var suckable_instance = possible_suckable_nodes[randi() % possible_suckable_nodes.size()].instantiate()
			suckable_instance.global_position = spawn_objects(previous_suckable_position, y_offset)
			suckable_instance.get_child(0).current_speed = object_speed
			gameplay_area.add_child(suckable_instance)
		for k in range(spawn_number_ouchables):
			var ouchable_instance = possible_ouch_nodes.instantiate()
			ouchable_instance.global_position = spawn_objects(previous_ouchable_position, y_offset)
			ouchable_instance.current_speed = object_speed
			gameplay_area.add_child(ouchable_instance)
