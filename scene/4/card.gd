extends MarginContainer


@onready var bg = $BG
@onready var aspects = $VBox/Aspects
@onready var granules = $VBox/Granules
@onready var slotIcon = $VBox/SlotIcon

var slot = null
var synergies = {}


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
	
	for synergy in Global.arr.synergy:
		if protocol_[synergy] != null:
			if !synergies.has(protocol_[synergy]):
				synergies[protocol_[synergy]] = 0
			
			synergies[protocol_[synergy]] += value


func get_aspects_assessment(weights_: Dictionary) -> int:
	var assessment = 0
	
	for aspect in aspects.get_children():
		if weights_.has(aspect.name):
			assessment += weights_[aspect.name] * int(aspect.label.text) 
	
	return assessment
