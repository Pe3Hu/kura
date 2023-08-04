extends MarginContainer


@onready var label = $Label

var value = 0
var card = null


func update_label_color() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
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


func update_label_value() -> void:
	label.text = str(value)
	
	if value != 0:
		visible = true
	else:
		visible = false


