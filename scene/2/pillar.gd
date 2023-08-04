extends MarginContainer


@onready var vbox = $VBox
@onready var bg = $BG
@onready var squads = $VBox/Squads

var paths = {}
var type = null
var arena = null
var altars = []


func _ready() -> void:
	pass


func set_pillar_side(altar_: MarginContainer) -> void:
	altars.append(altar_)
	add_path(altar_)
	
	if altars.size() == 2:
		add_squad(altar_, "obedience")
		add_squad(altar_, "dominance")
	else:
		add_squad(altar_, "dominance")
		add_squad(altar_, "obedience")


func add_path(altar_: MarginContainer) -> void:
	var path = Global.scene.path.instantiate()
	vbox.add_child(path)
	path.pillar = self
	path.altar = altar_
	paths[altar_] = path
	path.update_color_based_on_altar()


func add_squad(altar_: MarginContainer, type_: String) -> void:
	var squad = Global.scene.squad.instantiate()
	squads.add_child(squad)
	squad.pillar = self
	squad.type = type_
	squad.altar = altar_
	squad.update_color_based_on_type()


func update_color_based_on_type() -> void:
	var max_h = 360.0
	var s = 0.75
	var v = 1
	var h = 0
	
	match type:
		"tug of war":
			h = 210 / max_h
		2:
			h = 120 / max_h
		3:
			h = 270 / max_h
		4:
			h = 300 / max_h
		5:
			h = 60 / max_h
	
	var color_ = Color.from_hsv(h, s, v)
	bg.set_color(color_)
