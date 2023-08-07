extends MarginContainer


@onready var past = $VBox/Cards/Past
@onready var present = $VBox/Cards/Present
@onready var future = $VBox/Cards/Future
@onready var forgotten = $VBox/Cards/Forgotten
@onready var reserve = $VBox/Cards/Reserve
@onready var granules = $VBox/Granules


var hand = {}
var deck = {}


func _ready() -> void:
	hand.max = 6
	hand.draw = 4
	deck.max = 12
	set_basic_cards()
	pull_cards_from_reserve()
	draw_hand()


func set_basic_cards() -> void:
	for _i in 4:
		for aspect in Global.arr.aspect:
			var card = Global.scene.card.instantiate()
			reserve.add_child(card)
			var granule = Global.scene.granule.instantiate()
			granules.add_child(granule)
			granule.type = "root"
			var protocol = Global.scene.protocol.instantiate()
			protocol.operator = "add"
			protocol.value = 10
			protocol.aspect = aspect
			granule.apply_protocol(protocol)
			card.apply_granule(granule)
			
			granule = Global.scene.granule.instantiate()
			granules.add_child(granule)
			granule.type = "suffix"
			protocol = Global.scene.protocol.instantiate()
			protocol.operator = "add"
			protocol.value = 1
			protocol.totem = Global.dict.totem.title.keys().pick_random()#"Wolf"#
			granule.apply_protocol(protocol)
			card.apply_granule(granule)


func pull_cards_from_reserve() -> void:
	for _i in deck.max:
		if !reserve.get_children().is_empty(): 
			var card = reserve.get_children().front()
			pull_card_from_reserve(card)


func pull_card_from_reserve(card_: MarginContainer) -> void:
	var parent = card_.get_parent()
	parent.remove_child(card_)
	future.add_child(card_)


func draw_hand() -> void:
	for _i in hand.draw:
		var card = future.get_children().pick_random()
		card_transfer(card)


func card_transfer(card_: MarginContainer) -> void:
	var parent = card_.get_parent()
	parent.remove_child(card_)
	
	match parent.name:
		"Future":
			present.add_child(card_)
		"Present":
			past.add_child(card_)
		"Past":
			future.add_child(card_)
