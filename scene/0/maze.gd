extends MarginContainer


@onready var rooms = $Rooms
@onready var doors = $Doors

var rings = {}
var shift = false
var complete = false


func _ready() -> void:
	init_rooms()


func init_rooms() -> void:
	rings.room = []
	rings.type = []
	
	add_room(0, 0)
	add_ring("triple", false)
	add_ring("single", true)
	add_ring("triple", true)
	
	while !complete:
		var type = Global.get_random_key(Global.dict.ring.weight)
		add_ring(type, true)
		
		if Global.num.ring.segment < rings.room.back().size() / 3 - 1:
			complete = true
	print(rings.room.back().size() / 3 - 1)


func add_ring(type_: String, only_parent_: bool) -> void:
	var n = rings.room.back().size()
	
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
				shift = !shift
			"trapeze":
				if parents % 2 == 1:
					childs = (parents / 2) * 3 + 2
				else:
					return
		
		if Global.num.ring.segment < childs / 3:
			return
		
		n = (childs + 1) * 3
	
	rings.type.append(type_)
	rings.room.append([])
	var segment = n / 3
	var angle = {}
	angle.step = PI * 2 / n
	
	for _j in n:
		angle.current = angle.step * _j# - PI / 2
		
		if type_ == "equal":
			var sign = -1
			
			if !shift:
				sign = 0
			
			angle.current += sign * angle.step / 2
			
		add_room(angle.current, segment)
	
	add_doors(type_)


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


func add_doors(type_: String) -> void:
	var n = rings.room.size() - 1
	var k = 2
	var parents = rings.room[n - 1]
	var childs = rings.room[n]
	var segment = {}
	segment.parent = parents.size() / 3
	segment.child = childs.size() / 3
	var index = {}
	
	for _i in 3:
		#connect backdoor
		var a = parents[_i * segment.parent]
		var b = childs[_i * segment.child]
		connect_rooms(a, b)
		
	
		#connect letter
		if rings.type[n] == "equal" and rings.type[n - 1] == "equal":
			segment.elder = rings.room[n - 2].size() / 3
			index.elder = _i * segment.elder + segment.elder - 1
			index.child = _i * segment.child  + segment.child - 1
			a = rings.room[n - 2][index.elder]
			b = childs[index.child]
			connect_rooms(a, b)
		
		#connect segment
		if n == 2:
			for _j in 2:
				index.parent = (_i + _j) * segment.parent % parents.size()
				index.child = _i * segment.child  + 1
				a = parents[index.parent]
				b = childs[index.child]
				connect_rooms(a, b)
		else:
			for _j in segment.parent - 1:
				index.parent = _i * segment.parent + _j + 1
				a = parents[index.parent]
				
				match type_:
					"single":
							for _k in k:
								index.child = _i * segment.child + _j + _k + 1
								b = childs[index.child]
								connect_rooms(a, b)
					"double":
						for _k in k:
							index.child =  _i * segment.child + _j * k + _k + 1
							b = childs[index.child]
							connect_rooms(a, b)
					"triple":
						k = 3
						
						for _k in k:
							index.child =  _i * segment.child + _j * k + _k + 1
							b = childs[index.child]
							connect_rooms(a, b)
					"trapeze":
						if _j % 2 == 1:
							index.child = _i * segment.child + (_j / 2 + 1) * (k + 1)
							b = childs[index.child]
							connect_rooms(a, b)
						else:
							for _k in k:
								index.child = _i * segment.child + (_j / 2) * (k + 1) + _k + 1
								b = childs[index.child]
								connect_rooms(a, b)
					"equal":
						for _k in k:
							index.child = (_i * segment.child + _j + _k) % childs.size()
							
							if shift:
								index.child = (index.child + 1) % childs.size()
							
							b = childs[index.child]
							
							if !b.backdoor:
								connect_rooms(a, b)
	
	#connect ring
	if n > 2:
		for _i in childs.size():
			var a = childs[_i]
			var b = childs[(_i + 1) % childs.size()]
			
			if !(type_ == "equal" and (a.backdoor or b.backdoor)):
				connect_rooms(a, b)


func connect_rooms(a_: Polygon2D, b_: Polygon2D) -> void:
	if !a_.doors.has(b_):
		var door = Global.scene.door.instantiate()
		a_.doors[b_] = door
		b_.doors[a_] = door
		door.add_point(a_.position)
		door.add_point(b_.position)
		doors.add_child(door)
	else:
		print("door err", rings.room.size())
		a_.paint_white()
		b_.paint_white()
