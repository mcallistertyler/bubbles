extends RichTextLabel

var points_value : float = 0.0

func _ready() -> void:
	self.text = "[b][rainbow]Points: " + str(int(points_value)) + "[/rainbow][/b]"

func update_points_value(new_value : float):
	points_value = new_value
	self.text = "[b][rainbow]Points: " + str(int(points_value)) + "[/rainbow][/b]"
