extends MarginContainer


@onready var slots = $VBox/HBox/Slots
@onready var prototype = $VBox/Prototype
@onready var prefixs = $VBox/HBox/Prefixs
@onready var suffixs = $VBox/HBox/Suffixs


var totems = {}
var elements = {}
var kinds = {}


func _ready() -> void:
	for slot in slots.get_children():
		slot.prototype = prototype
		slot.forge = self
	
	set_default_slots()
	#prefix.draw_servant_affix("No")
	#suffix.draw_servant_affix("No")


func set_default_slots() -> void:
	prototype.reset()
	totems = {}
	elements = {}
	kinds = {}
	
	for slot in slots.get_children():
		slot.set_default()


func use_card(card_: MarginContainer) -> void:
	var slot = slots.get_node(card_.slot)
	card_.bg.visible = false
	
	for granule in card_.granules.get_children():
		for protocol in granule.protocols.get_children():
			var copy = protocol.get_copy()
			slot.apply_protocol(copy)


func add_affix(type_: String, title_: String) -> void:
	var icon = Global.scene.icon.instantiate()
	
	match type_:
		"totem":
			suffixs.add_child(icon)
	
	icon.draw_servant_affix(title_)
