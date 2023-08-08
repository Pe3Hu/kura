extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.aspect = ["power", "autonomy", "velocity"]


func init_num() -> void:
	num.index = {}
	num.index.servant = 0
	
	num.ring = {}
	num.ring.r = 32
	num.ring.segment = 9
	
	num.room = {}
	num.room.r = 12


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.ring = {}
	dict.ring.weight = {}
	dict.ring.weight["single"] = 7
	dict.ring.weight["trapeze"] = 5
	dict.ring.weight["equal"] = 9
	dict.ring.weight["double"] = 3
	#dict.ring.weight["triple"] = 1
	
	dict.slot = {}
	dict.slot.aspect = {}
	dict.slot.aspect["Head"] = "power"
	dict.slot.aspect["Torso"] = "autonomy"
	dict.slot.aspect["Limb"] = "velocity"
	
	dict.aspect = {}
	dict.aspect.slot = {}
	dict.aspect.slot["power"] = "Head"
	dict.aspect.slot["autonomy"] = "Torso"
	dict.aspect.slot["velocity"] = "Limb"
	
	dict.icon = {}
	
	init_spells()
	init_origins()
	init_kinds()
	init_totems()
	init_traits()
	

func init_spells() -> void:
	dict.spell = {}
	dict.spell.calibration = {}
	var path = "res://asset/json/kura_calibration.json"
	var array = load_data(path)
	
	for data in array:
		if !dict.spell.calibration.has(data.type):
			dict.spell.calibration[data.type] = {}
		
		dict.spell.calibration[data.type][data.title] = data.duplicate()
		
		if data.type == data.subtype:
			dict.spell.calibration[data.type][data.title].erase("subtype")
		
		dict.spell.calibration[data.type][data.title].erase("type")
		dict.spell.calibration[data.type][data.title].erase("title")
	
	dict.spell.symbol = {}
	dict.icon.symbol = {}
	path = "res://asset/json/kura_symbol.json"
	array = load_data(path)
	
	for data in array:
		dict.spell.symbol[data.title] = {}
		dict.icon.symbol[data.title] = {}
		
		for key in data:
			if key != "title" and data[key] != 0:
				dict.spell.symbol[data.title][key] = data[key]
				dict.icon.symbol[data.title][key] = 0
				
				while dict.icon.symbol[data.title][key] + 1 <= data[key] / 25:
					dict.icon.symbol[data.title][key] += 1
	


func init_origins() -> void:
	dict.origin = {}
	dict.origin.title = {}
	var path = "res://asset/json/kura_origin.json"
	var array = load_data(path)
	
	for data in array:
		dict.origin.title[data.title] = data
		dict.origin.title[data.title].erase("title")


func init_kinds() -> void:
	dict.kind = {}
	dict.kind.title = {}
	var path = "res://asset/json/kura_kind.json"
	var array = load_data(path)
	
	for data in array:
		dict.kind.title[data.title] = data
		dict.kind.title[data.title].erase("title")


func init_totems() -> void:
	dict.totem = {}
	dict.totem.title = {}
	var path = "res://asset/json/kura_totem.json"
	var array = load_data(path)
	
	for data in array:
		dict.totem.title[data.title] = data
		dict.totem.title[data.title].erase("title")


func init_traits() -> void:
	dict.trait = {}
	dict.trait.title = {}
	var path = "res://asset/json/kura_trait.json"
	var array = load_data(path)
	
	for data in array:
		dict.trait.title[data.title] = {}
		
		for key in data:
			if key != "title":
				dict.trait.title[data.title][int(key)] = data[key]


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.blank = load("res://scene/0/blank.tscn")
	scene.maze = load("res://scene/1/maze.tscn")
	scene.room = load("res://scene/1/room.tscn")
	scene.door = load("res://scene/1/door.tscn")
	scene.arena = load("res://scene/2/arena.tscn")
	scene.altar = load("res://scene/2/altar.tscn")
	scene.pillar = load("res://scene/2/pillar.tscn")
	scene.path = load("res://scene/2/path.tscn")
	scene.rope = load("res://scene/2/rope.tscn")
	scene.influence = load("res://scene/2/influence.tscn")
	scene.forge = load("res://scene/3/forge.tscn")
	scene.slot = load("res://scene/3/slot.tscn")
	scene.squad = load("res://scene/3/squad.tscn")
	scene.traveler = load("res://scene/3/traveler.tscn")
	scene.servant = load("res://scene/3/servant.tscn")
	scene.library = load("res://scene/4/library.tscn")
	scene.card = load("res://scene/4/card.tscn")
	scene.granule = load("res://scene/4/granule.tscn")
	scene.protocol = load("res://scene/4/protocol.tscn")
	scene.aspects = load("res://scene/4/aspects.tscn")
	scene.aspect = load("res://scene/4/aspect.tscn")
	scene.icon = load("res://scene/4/icon.tscn")
	


func init_vec():
	vec.size = {}
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
