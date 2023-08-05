extends MarginContainer


@onready var bg = $BG
@onready var length = $VBox/Length
@onready var travelers = $VBox/Travelers


var pillar = null
var altar = null


func update_color_based_on_altar() -> void:
	var max_h = 360.0
	var s = 0
	var v = 1
	var h = 0
	
	match altar.lord:
		"player":
			pass
		"not player":
			v = 0
	
	var color_ = Color.from_hsv(h, s, v)
	bg.set_color(color_)
