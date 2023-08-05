extends MarginContainer


@onready var bg = $BG
@onready var library = $VBox/Library
@onready var forge = $VBox/Forge

var lord = null
var arena = null


func select_cards() -> void:
	for card in library.present.get_children():
		forge.use_card(card)


func create_servant() -> void:
	var servant = forge.prototype.get_copy()
	servant.altar = self
	servant.purpose = "obedience"
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
