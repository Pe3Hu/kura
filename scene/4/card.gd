extends MarginContainer


@onready var bg = $BG
@onready var aspects = $VBox/Aspects
@onready var granules = $VBox/Granules
@onready var slotIcon = $VBox/SlotIcon

var slot = null


func apply_granule(granule_: MarginContainer) -> void:
	granule_.get_parent().remove_child(granule_)
	granules.add_child(granule_)
	granule_.card = self
	
	for protocol in granule_.protocols.get_children():
		apply_protocol(protocol)


func apply_protocol(protocol_: MarginContainer) -> void:
	if slot == null:
		slot = Global.dict.aspect.slot[protocol_.aspect]
		slotIcon.draw_slot_type(slot)
		
	var value = protocol_.value
	
	match protocol_.operator:
		"add":
			value *= 1
	
	if protocol_.aspect != null:
		var aspect = aspects.get_node(protocol_.aspect)
		aspect.add_value(value)
