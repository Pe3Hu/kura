extends MarginContainer


@onready var aspects = $VBox/HBox/Aspects

var index = null
var altar = null
var purpose = null
var squad = null
var dead = false


func _ready() -> void:
	aspects.servant = self


func reset() -> void:
	for aspect in aspects.get_children():
		aspect.reset()


func get_copy() -> MarginContainer:
	var servant = self.duplicate()
	servant.aspects = Global.scene.aspects.instantiate()
	
	for _i in aspects.get_child_count():
		servant.aspects.get_child(_i).label = servant.aspects.get_child(_i).get_node("Label")
		servant.aspects.get_child(_i).reset() 
		servant.aspects.get_child(_i).add_value(int(get_aspect_value(servant.aspects.get_child(_i).name)))
		#print([servant.aspects.get_child(_i).value, servant.aspects.get_child(_i).label.text])
	
	return servant


func get_aspect_value(aspect_: String) -> Variant:
	var aspect = aspects.get_node(aspect_)
	return int(aspect.label.text)


func subdue() -> void:
	var max = get_aspect_value("power")
	Global.rng.randomize()
	var value = Global.rng.randi_range(0, max)
	squad.pillar.rope.add_influence(altar, value)


func die() -> void:
	dead = true
	squad.pillar.graveyard.add_servant(self)
