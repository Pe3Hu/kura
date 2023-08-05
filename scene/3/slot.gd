extends MarginContainer


@onready var protocols = $Protocols

var prototype = null


func set_default() -> void:
	for protocol in protocols.get_children():
		protocols.remove_child(protocol)
	
	var protocol = Global.scene.protocol.instantiate()
	protocol.operator = "add"
	protocol.value = 5
	protocol.default = true
	protocol.aspect = Global.dict.slot.aspect[name]
	apply_protocol(protocol)


func apply_protocol(protocol_: MarginContainer) -> void:
	remove_default()
	protocols.add_child(protocol_)
	protocol_.update()
	var value = protocol_.value
	
	match protocol_.operator:
		"add":
			value *= 1
	
	var aspect = prototype.aspects.get_node(protocol_.aspect)
	aspect.value += value
	aspect.update_label_value()


func remove_default() -> void:
	if protocols.get_child_count() == 1:
		var protocol = protocols.get_child(0)
		
		if protocol.default:
			protocols.remove_child(protocol)
			protocol.queue_free()
			
			var aspect = prototype.aspects.get_node(protocol.aspect)
			aspect.value = 0
