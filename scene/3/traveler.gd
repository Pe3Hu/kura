extends MarginContainer


@onready var index = $VBox/Index
@onready var milestone = $VBox/Milestone

var path = null
var servant = null


func move() -> void:
	var max = servant.get_aspect_value("velocity")
	Global.rng.randomize()
	var step = Global.rng.randi_range(0, max)
	var length = int(milestone.text) + step + 50
	
	if length >= int(path.length.text):
		path.pillar.traveler_arrival(self)
	else:
		milestone.text = str(length)
