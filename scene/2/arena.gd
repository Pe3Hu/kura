extends MarginContainer


@onready var vbox = $HBox
@onready var pillars = $HBox/Pillars
@onready var timer = $Timer

var altars = []


func _ready() -> void:
	init_pillars()
	init_altars()
	set_path_lengths()
	update_pillars()


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
	altar.forge.reset()
	
	if altars.is_empty():
		altar.lord = "player"
	else:
		altar.lord = "not player"
	
	altars.append(altar)
	
	for pillar in pillars.get_children():
		pillar.set_pillar_side(altar)
	
	altar.update_color_based_on_lord()


func set_path_lengths() -> void:
	var arrangement = "one off center"
	var a = 100
	var h = a * sqrt(3) / 2
	var centers = {}
	
	for _i in pillars.get_child_count():
		var pillar = pillars.get_child(_i)
		var x = a * (_i - pillars.get_child_count() / 2)
		var dot = Vector2(x, 0)
		
		for _j in altars.size():
			var altar = altars[_j]
			var center = Vector2(0, h)
			
			if _j == 0:
				center *= -1
			
			match arrangement:
				"one off center":
					if _j == 0:
						center.x -= a
					else:
						center.x += a
			
			var path = pillar.paths[altar]
			var length = floor(dot.distance_to(center))
			path.length.text = str(length)


func update_pillars() -> void:
	for pillar in pillars.get_children():
		match pillar.type:
			"tug of war":
				pillar.add_rope()


func _at_end_of_round() -> void:
	for altar in altars:
		altar.round_start()
	
	move_travelers()
	promote_obedience()
	promote_dominance()


func move_travelers() -> void:
	for pillar in pillars.get_children():
		for altar in pillar.paths:
			var path = pillar.paths[altar]
			
			for _i in range(path.travelers.get_child_count()-1, -1, -1):
				var traveler = path.travelers.get_child(_i)
				traveler.move()


func promote_obedience() -> void:
	for pillar in pillars.get_children():
		if pillar.rope != null:
			for altar in pillar.obediences:
				for servant in pillar.obediences[altar].servants.get_children():
					servant.subdue()


func promote_dominance() -> void:
	for pillar in pillars.get_children():
		pillar.scramble.start()
