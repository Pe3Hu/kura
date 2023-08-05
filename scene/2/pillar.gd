extends MarginContainer


@onready var vbox = $HBox
@onready var bg = $BG
@onready var squads = $HBox/Squads

var paths = {}
var obediences = {}
var dominances = {}
var type = null
var arena = null
var rope = null
var altars = []


func _ready() -> void:
	pass


func set_pillar_side(altar_: MarginContainer) -> void:
	altars.append(altar_)
	add_path(altar_)
	
	if altars.size() == 1:
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


func add_squad(altar_: MarginContainer, purpose_: String) -> void:
	var squad = Global.scene.squad.instantiate()
	squads.add_child(squad)
	squad.pillar = self
	squad.purpose = purpose_
	squad.altar = altar_
	get(purpose_+"s")[altar_] = squad
	squad.update_color_based_on_type()


func traveler_arrival(traveler_: MarginContainer) -> void:
	traveler_.servant.squad = get_squad_for_servant(traveler_.servant)
	traveler_.servant.squad.servants.add_child(traveler_.servant)
	traveler_.servant.aspects.get_node("velocity").visible = false
	traveler_.get_parent().remove_child(self)
	traveler_.queue_free()


func get_squad_for_servant(servant_: MarginContainer) -> Variant:
	for squad in squads.get_children():
		if squad.get("purpose") != null and squad.get("altar") != null:
			if squad.purpose == servant_.purpose and squad.altar == servant_.altar:
				return squad
	
	return null


func add_rope() -> void:
	rope = Global.scene.rope.instantiate()
	squads.add_child(rope)
	squads.move_child(rope, 2)
	
	for altar in altars:
		var influence = Global.scene.influence.instantiate()
		rope.influences.add_child(influence)
		influence.altar = altar
		influence.pillar = self


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
