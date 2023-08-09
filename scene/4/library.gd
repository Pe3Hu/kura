extends MarginContainer


@onready var past = $VBox/Cards/Past
@onready var present = $VBox/Cards/Present
@onready var future = $VBox/Cards/Future
@onready var forgotten = $VBox/Cards/Forgotten
@onready var reserve = $VBox/Cards/Reserve
@onready var granules = $VBox/Granules


var hand = {}
var deck = {}
var synergies = {}


func _ready() -> void:
	hand.max = 6
	hand.draw = 4
	deck.max = 12
	set_basic_cards()
	pull_cards_from_reserve()
	draw_hand()


func set_basic_cards() -> void:
	var values = []
	var value = 10
	var sum = 0
	
	for _i in 3:
		value += Global.arr.sequence["A000040"][_i]
		for aspect in Global.arr.aspect.size() * 4 / 3:
			values.append(value)
			sum += value
	
	values.shuffle()
	#print([values, sum])
	
	for _i in 4:
		for aspect in Global.arr.aspect:
			var card = Global.scene.card.instantiate()
			reserve.add_child(card)
			var granule = Global.scene.granule.instantiate()
			granules.add_child(granule)
			granule.type = "root"
			var protocol = Global.scene.protocol.instantiate()
			protocol.operator = "add"
			protocol.value = values.pop_front()
			protocol.aspect = aspect
			granule.apply_protocol(protocol)
			card.apply_granule(granule)
			
			granule = Global.scene.granule.instantiate()
			granules.add_child(granule)
			granule.type = "suffix"
			protocol = Global.scene.protocol.instantiate()
			protocol.operator = "add"
			protocol.value = 1
			#protocol.totem = Global.dict.totem.title.keys().pick_random()#"Wolf"#
			#protocol.origin = Global.dict.origin.title.keys().pick_random()#"Wolf"#
			protocol.kind = Global.dict.kind.title.keys().pick_random()#"Wolf"#
			granule.apply_protocol(protocol)
			card.apply_granule(granule)
	
	set_synergies()


func set_synergies() -> void:
	synergies = {}
	
	for card in reserve.get_children():
		for synergy in card.synergies:
			if !synergies.has(synergy):
				synergies[synergy] = {}
			
			if !synergies[synergy].has(card.slot):
				synergies[synergy][card.slot] = 0
			
			synergies[synergy][card.slot] += 1
	
	
	for _i in range(synergies.keys().size()-1, -1, -1):
		var synergy = synergies.keys()[_i]
		
		if synergies[synergy].keys().size() < 2:
			synergies.erase(synergy)
		else:
			var total = 0
			
			for slot in synergies[synergy]:
				total += synergies[synergy][slot]
			
			synergies[synergy].total = total
	
	print(synergies)


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
