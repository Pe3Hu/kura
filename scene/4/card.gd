extends MarginContainer


@onready var aspects = $Aspects

var protocols = []


func _ready() -> void:
	for type in Global.arr.aspect:
		var aspect = Global.scene.aspect.instantiate()
		aspect.name = type
		aspect.card = self
		aspects.add_child(aspect)
		aspect.update_label_color()


func add_protocol(data_: Dictionary) -> void:
	protocols.append(data_)
	apply_protocol(data_)


func apply_protocol(data_: Dictionary) -> void:
	var value = data_.value
	
	match data_.operator:
		"add":
			value *= 1
	
	var aspect = aspects.get_node(data_.aspect)
	aspect.value += value
	aspect.update_label_value()
