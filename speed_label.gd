extends RichTextLabel

var speed_value : float = 0.0

func update_speed_value(new_value : float):
	speed_value = new_value
	self.text = "[b][rainbow]Speed: " + str(int(speed_value)) + "[/rainbow][/b]"
