extends MarginContainer


@onready var bg = $BG
@onready var library = $VBox/Library
@onready var forge = $VBox/Forge

var lord = null
var arena = null


func select_cards() -> void:
	find_synergies()
	finish_leftovers()


func aspects_assessment(synergies: Variant) -> void:
	var weights = Global.dict.icon.symbol[forge.symbol]
	var assessments = {}
	
	for card in library.present.get_children():
		var flag = synergies == null
		
		if !flag:
			for synergy in synergies:
				if card.synergies.has(synergy):
					flag = true
		
		if flag:
			var slot = forge.slots.get_node(card.slot)
			
			if slot.cards.is_empty():
				var assessment = card.get_aspects_assessment(weights)
				
				if assessment > 0:
					assessments[card] = card.get_aspects_assessment(weights)
	
	while !assessments.keys().is_empty():
		var card = Global.get_random_key(assessments)
		assessments.erase(card)
		forge.use_card(card)
		var slot = forge.slots.get_node(card.slot)
		
		if !slot.cards.is_empty():
			for _i in range(assessments.keys().size()-1, -1, -1):
				card = assessments.keys()[_i]
				
				if card.slot == slot.name:
					assessments.erase(card)
	
	if synergies != null:
		finish_synergy(synergies)


func find_synergies() -> void:
	var synergies = {}
	
	for card in library.present.get_children():
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
	
	print(synergies)
	
	if !synergies.keys().is_empty():
		aspects_assessment(synergies)
	else:
		aspects_assessment(null)


func finish_synergy(synergies_: Dictionary) -> void:
	var slots = {}
	
	if synergies_ != null:
		for card in library.present.get_children():
			var slot = forge.slots.get_node(card.slot)
			
			if card.bg.visible and slot.cards.is_empty():
				for synergy in card.synergies:
					if synergies_.has(synergy):
						if !slots.has(card.slot):
							slots[card.slot] = []
						
						slots[card.slot].append(card)
	
	for slot in slots:
		var card = slots[slot].pick_random()
		forge.use_card(card)



func finish_leftovers() -> void:
	var slots = {}
	
	for card in library.present.get_children():
		var slot = forge.slots.get_node(card.slot)
		
		if card.bg.visible and slot.cards.is_empty():
			var leftover = true
			
			for synergy in card.synergies:
				if library.synergies.has(synergy):
					leftover = false
					break
			
			if leftover:
				if !slots.has(card.slot):
					slots[card.slot] = []
				
				slots[card.slot].append(card)
	
	for slot in slots:
		var card = slots[slot].pick_random()
		forge.use_card(card)



func create_servant() -> void:
	var servant = forge.prototype.get_copy()
	servant.altar = self
	servant.purpose = "dominance"#"obedience"
	servant.index = Global.num.index.servant
	Global.num.index.servant += 1
	var traveler = Global.scene.traveler.instantiate()
	var path = choose_path()
	path.travelers.add_child(traveler)
	traveler.path = path
	traveler.servant = servant
	traveler.index.text = str(servant.index)
	traveler.milestone.text = str(0)
	forge.set_default_slots()


func choose_path() -> MarginContainer:
	var pillar = arena.pillars.get_child(0)
	var path = pillar.paths[self]
	return path


func update_color_based_on_lord() -> void:
	var max_h = 360.0
	var s = 0
	var v = 1
	var h = 0
	
	match lord:
		"player":
			pass
		"not player":
			v = 0
	
	var color_ = Color.from_hsv(h, s, v)
	bg.set_color(color_)
