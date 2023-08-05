extends MarginContainer


@onready var label = $Label

var value = null
var operator = null
var aspect = null
var default = false
var effect = null


func update() -> void:
	update_label_color()
	update_label_value()


func update_label_color() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match aspect:
		"power":
			h = 0 / max_h
		"autonomy":
			h = 240 / max_h
		"velocity":
			h = 120 / max_h
	
	var color_ = Color.from_hsv(h, s, v)
	label.set("theme_override_colors/font_color", color_)


func update_label_value() -> void:
	match operator:
		"add":
			label.text = "+"
	
	label.text += str(value)


func get_copy() -> MarginContainer:
	var protocol = Global.scene.protocol.instantiate()

	var props = get_script().get_script_property_list()
	
	for prop in props:
		if prop.name != "protocol.gd" and prop.name != "label":
			protocol[prop.name] = get(prop.name)
			#print("name: ", prop.name, ", value: ", get(prop.name), ", type: ", prop.type)
	
	return protocol
