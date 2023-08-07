extends MarginContainer


@onready var label = $Label

var card = null
var value = null


func update_label_color() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 0.9
	var h = 0
	
	match name:
		"power":
			h = 0 / max_h
		"autonomy":
			h = 240 / max_h
		"velocity":
			h = 120 / max_h
	
	var color_ = Color.from_hsv(h, s, v)
	label.set("theme_override_colors/font_color", color_)


func add_value(value_: int) -> void:
	label.text = str(int(label.text) + value_)
	
	if int(label.text) != 0:
		visible = true
	else:
		visible = false
	
	if int(label.text) < 0:
		get_parent().servant.die()


func reset() -> void:
	label.text = "0"
