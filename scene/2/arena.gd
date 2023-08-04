extends MarginContainer


@onready var vbox = $VBox
@onready var pillars = $VBox/Pillars

var altars = []


func _ready() -> void:
	init_pillars()
	init_altars()


func init_pillars() -> void:
	var types = ["tug of war", "tug of war", "tug of war"]
	
	for type in types:
		var pillar = Global.scene.pillar.instantiate()
		pillar.type = type
		add_pillar(pillar)


func add_pillar(pillar_: MarginContainer) -> void:
	pillars.add_child(pillar_)
	pillar_.arena = self
	pillar_.update_color_based_on_type()


func init_altars() -> void:
	add_altar()
	add_altar()
	
	#move player altar
	var altar = vbox.get_child(1)
	vbox.move_child(altar, 0)
	
	#move player paths
	for pillar in pillars.get_children():
		var path = pillar.paths[altar]
		pillar.vbox.move_child(path, 0)


func add_altar() -> void:
	var altar = Global.scene.altar.instantiate()
	vbox.add_child(altar)
	altar.arena = self
	
	if altars.is_empty():
		altar.lord = "player"
	else:
		altar.lord = "not player"
	
	altars.append(altar)
	
	for pillar in pillars.get_children():
		pillar.set_pillar_side(altar)
	
	altar.update_color_based_on_lord()
