extends MarginContainer


@onready var protocols = $Protocols

var prototype = null
var forge = null
var cards = []


func set_default() -> void:
	cards = []
	
	for protocol in protocols.get_children():
		protocols.remove_child(protocol)
	
	var protocol = Global.scene.protocol.instantiate()
	protocol.operator = "add"
	protocol.value = 10
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
	
	if protocol_.aspect != null:
		var aspect = prototype.aspects.get_node(protocol_.aspect)
		aspect.add_value(value)
	
	var affixs = ["totem", "origin", "kind"]
	
	for affix in affixs:
		if protocol_[affix] != null:
			if !forge.totems.has(protocol_[affix]):
				forge.totems[protocol_[affix]] = 0
			
			if forge.totems[protocol_[affix]] < 2:
				forge.totems[protocol_[affix]] += value
				
				if forge.totems[protocol_[affix]] >= 2:
					forge.add_affix(affix, protocol_[affix])


func remove_default() -> void:
	if protocols.get_child_count() == 1:
		var protocol = protocols.get_child(0)
		
		if protocol.default:
			protocols.remove_child(protocol)
			protocol.queue_free()
			var aspect = prototype.aspects.get_node(protocol.aspect)
			aspect.reset()
