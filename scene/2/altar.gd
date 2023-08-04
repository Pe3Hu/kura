extends MarginContainer


@onready var bg = $BG
@onready var library = $VBox/Library

var lord = null
var arena = null


func update_color_based_on_lord() -> void:
	var max_h = 360.0
	var s = 0
	var v = 1
	var h = 0
	
	match lord:
		"player":
			pass
		"not player":
			v = 0
	
	var color_ = Color.from_hsv(h, s, v)
	bg.set_color(color_)
