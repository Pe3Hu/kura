extends MarginContainer


@onready var rooms = $Rooms

var rings = {}


func _ready() -> void:
	init_rooms()


func init_rooms() -> void:
	rings.room = []
	rings.type = []
	
	add_room(0, 0)
	add_ring("triple", false)
	add_ring("single", true)
	#add_ring("double", false)
	add_ring("single", true)
	add_ring("single", true)
	#add_ring("triple", true)
	add_ring("trapeze", true)
	add_ring("equal", true)


func add_ring(type_: String, only_parent_: bool) -> void:
	var n = rings.room.back().size()
	rings.type.append(type_)
	
	if !only_parent_:
		match type_:
			"triple":
				n *= 3
	else:
		var parents = rings.room.back().size() / 3 - 1
		var childs = null
		
		match type_:
			"triple":
				childs = parents * 3
			"double":
				childs = parents * 2
			"single":
				childs = parents + 1
			"equal":
				childs = parents
			"trapeze":
				if parents % 2 == 1:
					childs = (parents / 2) * 3 + 2
		
		n = (childs + 1) * 3
	
	rings.room.append([])
	var segment = n / 3
	var angle = {}
	angle.step = PI * 2 / n
	
	for _j in n:
		angle.current = angle.step * _j - PI / 2
		
		if type_ == "equal":
			angle.current += angle.step / 2
			
		add_room(angle.current, segment)


func add_room(angle_: float, segment_: int) -> void:
	var room = Global.scene.room.instantiate()
	
	if rings.room.size() > 0:
		room.ring = rings.room.size() - 1
	else:
		room.ring = 0
		rings.room.append([])
		rings.type.append(null)
		
	room.order = rings.room[room.ring].size()
	rings.room[room.ring].append(room)
	room.maze = self
	room.position += size * 0.5
	room.position += Vector2().from_angle(angle_) * Global.num.ring.r * room.ring
	rooms.add_child(room)
	
	if room.ring > 1:
		if  room.order % segment_ == 0:
			room.backdoor = true
	
	room.update_color_based_on_ring()
