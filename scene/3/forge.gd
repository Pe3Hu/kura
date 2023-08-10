extends MarginContainer


@onready var slots = $VBox/HBox/Slots
@onready var prototype = $VBox/Prototype
@onready var prefixs = $VBox/HBox/Prefixs
@onready var suffixs = $VBox/HBox/Suffixs

var altar = null
var totems = {}
var origins = {}
var kinds = {}
var symbol = null
var purpose = null
var calibration = {}


func _ready() -> void:
	for slot in slots.get_children():
		slot.prototype = prototype
		slot.forge = self
	
	calibration.balance = 0


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
	
	symbol = Global.dict.spell.symbol.keys().pick_random()
	add_affix("symbol", symbol)
	
	purpose = altar.purposes.pick_random()
	
	if purpose == "obedience":
		calibration.aspect = null
		calibration.servant = null
	else:
		set_calibrations()
	
	add_affix("purpose", purpose)


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
		"purpose":
			prefixs.add_child(icon)
			icon.draw_purpose(calibration)
	
	icon.draw_servant_affix(title_)


func set_calibrations() -> void:
	var limit = {}
	var balance = Global.dict.calibration.base + calibration.balance
	limit.min = max(Global.dict.calibration.min, balance - Global.dict.calibration.dispersion / 2)
	limit.max = limit.min + Global.dict.calibration.dispersion
	
	if limit.max > Global.dict.calibration.max:
		limit.max = Global.dict.calibration.max
		limit.min = limit.max - Global.dict.calibration.dispersion
	
	Global.rng.randomize()
	var price = Global.rng.randi_range(limit.min, limit.max)
	balance += Global.dict.calibration.base - price
	
	var calibration_ = Global.dict.calibration.price[price].pick_random()
	calibration.aspect = calibration_.aspect
	calibration.servant = calibration_.servant


func use_card(card_: MarginContainer) -> void:
	var slot = slots.get_node(card_.slot)
	slot.cards.append(card_)
	#card_.bg.visible = false
	altar.library.card_transfer(card_)
	
	for granule in card_.granules.get_children():
		for protocol in granule.protocols.get_children():
			var copy = protocol.get_copy()
			slot.apply_protocol(copy)
