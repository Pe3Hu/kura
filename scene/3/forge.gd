extends MarginContainer


@onready var slots = $VBox/Slots
@onready var prototype = $VBox/Prototype


func _ready() -> void:
	for slot in slots.get_children():
		slot.prototype = prototype
	
	set_default_slots()


func set_default_slots() -> void:
	prototype.reset()
	
	for slot in slots.get_children():
		slot.set_default()


func use_card(card_: MarginContainer) -> void:
	var slot = slots.get_node(card_.slot)
	card_.bg.visible = false
	
	for protocol in card_.protocols.get_children():
		var copy = protocol.get_copy()
		slot.apply_protocol(copy)

