extends MarginContainer


@onready var label = $VBox/Label
@onready var squares = $VBox/Squares


func draw_servant_affix(status_: String) -> void:
	if !label.visible:
		label.visible = true
		label.text = status_


func draw_slot_type(slot_: String) -> void:
	squares.visible = true
	var index = Global.dict.slot.aspect.keys().find(slot_)
	
	for _i in 3:
		var blank = Global.scene.blank.instantiate()
		squares.add_child(blank)
		
		if _i == index:
			blank.bg.set_color(Color.DARK_GRAY)
		else:
			blank.bg.set_color(Color.LIGHT_GRAY)


func draw_spell_symbol(symbol_: String) -> void:
	squares.visible = true
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	for aspect in Global.dict.icon.symbol[symbol_]:
		for _i in Global.dict.icon.symbol[symbol_][aspect]:
			var blank = Global.scene.blank.instantiate()
			squares.add_child(blank)
			
			match aspect:
				"power":
					h = 0 / max_h
				"autonomy":
					h = 240 / max_h
				"velocity":
					h = 120 / max_h
			
			var color_ = Color.from_hsv(h, s, v)
			blank.bg.set_color(color_)


func draw_purpose(calibration_: Dictionary) -> void:
	label.visible = true
	
	if calibration_.servant == null:
		label.text = "obedience"
	else:
		label.text = calibration_.aspect + " " + calibration_.servant


func draw_index(index_: int) -> void:
	if !label.visible:
		label.visible = true
		label.text = str(index_)
