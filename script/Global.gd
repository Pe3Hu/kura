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


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.maze = load("res://scene/1/maze.tscn")
	scene.room = load("res://scene/1/room.tscn")
	scene.door = load("res://scene/1/door.tscn")
	scene.arena = load("res://scene/2/arena.tscn")
	scene.altar = load("res://scene/2/altar.tscn")
	scene.pillar = load("res://scene/2/pillar.tscn")
	scene.path = load("res://scene/2/path.tscn")
	scene.squad = load("res://scene/3/squad.tscn")
	scene.servant = load("res://scene/3/servant.tscn")
	scene.library = load("res://scene/4/library.tscn")
	scene.card = load("res://scene/4/card.tscn")
	scene.aspect = load("res://scene/4/aspect.tscn")
	


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
