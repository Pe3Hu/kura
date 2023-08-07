extends MarginContainer


@onready var label = $VBox/Label
@onready var squares = $VBox/Squares


func draw_servant_affix(status_: String) -> void:
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
