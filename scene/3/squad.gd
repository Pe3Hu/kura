extends MarginContainer


@onready var bg = $BG
@onready var servants = $Servants

var pillar = null
var altar = null
var purpose = null


func update_color_based_on_type() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match purpose:
		"obedience":
			h = 60 / max_h
		"dominance":
			h = 0 / max_h
	
	var color_ = Color.from_hsv(h, s, v)
	bg.set_color(color_)
