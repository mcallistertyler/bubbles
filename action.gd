extends Node2D

@onready var microphone : BubbleMicrophone = get_node("%Microphone")

func _on_button_pressed() -> void:
	microphone.start_recording()
