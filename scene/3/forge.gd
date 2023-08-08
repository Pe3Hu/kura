extends MarginContainer


@onready var slots = $VBox/HBox/Slots
@onready var prototype = $VBox/Prototype
@onready var prefixs = $VBox/HBox/Prefixs
@onready var suffixs = $VBox/HBox/Suffixs


var totems = {}
var origins = {}
var kinds = {}


func _ready() -> void:
	for slot in slots.get_children():
		slot.prototype = prototype
		slot.forge = self
	
	reset()


func reset() -> void:
	prototype.reset()
	totems = {}
	origins = {}
	kinds = {}
	
	set_default_slots()
	reset_affixs()


func set_default_slots() -> void:
	for slot in slots.get_children():
		slot.set_default()


func reset_affixs() -> void:
	for prefix in prefixs.get_children():
		prefixs.remove_child(prefix)
		prefix.queue_free()
	
	for suffix in suffixs.get_children():
		suffixs.remove_child(suffix)
		suffix.queue_free()
	
	var symbol = Global.dict.spell.symbol.keys().pick_random()
	add_affix("symbol", symbol)


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
		"kind":
			suffixs.add_child(icon)
		"origin":
			suffixs.add_child(icon)
		"symbol":
			prefixs.add_child(icon)
			icon.draw_spell_symbol(title_)
	
	icon.draw_servant_affix(title_)
