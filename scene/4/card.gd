extends MarginContainer


@onready var bg = $BG
@onready var aspects = $VBox/Aspects
@onready var protocols = $VBox/Protocols

var slot = null


func apply_protocol(protocol_: MarginContainer) -> void:
	protocols.add_child(protocol_)
	protocol_.update()
	var value = protocol_.value
	
	match protocol_.operator:
		"add":
			value *= 1
	
	var aspect = aspects.get_node(protocol_.aspect)
	aspect.value += value
	aspect.update_label_value()
