extends AudioStreamPlayer

@export var possible_audio : Array[AudioStreamMP3] = []

func _ready() -> void:
	var selected_stream = possible_audio.pick_random()
	self.stream = selected_stream
	
func play_death():
	self.play(0.0)
