extends MarginContainer


var queue = []
var end = false


func start() -> void:
	queue = []
	end = false
	set_servant_queue()
	
	if !queue.is_empty():
		queue_up()


func set_servant_queue() -> void:
	var datas = {}
	var keys = []
	
	for purpose in Global.arr.purpose:
		var key = purpose + "s"
		keys.append(key)
	
	#if get_parent().rope == null:
	#	keys.append("obediences")
	
	for key in keys:
		for altar in get_parent().get(key):
			var squad = get_parent().get(key)[altar]
			
			for servant in squad.servants.get_children():
				var velocity = servant.get_aspect_value("velocity")
				
				if !datas.has(velocity):
					datas[velocity] = []
				
				var data = {}
				data.index = int(servant.index.label.text)
				data.servant = servant
				datas[velocity].append(data)
	
	for velocity in datas:
		datas[velocity].sort_custom(func(a, b): return a.index < b.index)
		
		for data in datas[velocity]:
			queue.append(data.servant)


func queue_up() -> void:
	for _i in range(queue.size()-1, -1, -1):
		if !end:
			var servant = queue[_i]
			activate(servant)
		else:
			return


func activate(servant_: MarginContainer) -> void:
	if check_foe(servant_.altar) and servant_.purpose == "dominance":
		var foe = get_foe(servant_)
		press(servant_, foe)
	else:
		end = true


func check_foe(altar_: MarginContainer) -> bool:
	for servant in queue:
		if servant.altar != altar_:
			return true
	
	return false


func get_foe(servant_: MarginContainer) -> MarginContainer:
	var index = queue.find(servant_)
	var datas = []
	
	for servant in queue:
		if servant.altar != servant_.altar:
			var data = {}
			data.servant = servant
			data.index = queue.find(servant)
			data.proximity = abs(data.index - index)
			datas.append(data)
	
	datas.sort_custom(func(a, b): return a.proximity < b.proximity)
	print(datas.front().servant.index)
	return datas.front().servant


func press(servant_: MarginContainer, foe_: MarginContainer) -> void:
	var max = {}
	max.servant = servant_.get_aspect_value("power")
	Global.rng.randomize()
	var attack = Global.rng.randi_range(0, max.servant)
	max.foe = foe_.get_aspect_value("autonomy")
	Global.rng.randomize()
	var defense = Global.rng.randi_range(0, max.foe)
	
	if attack > defense:
		var aspect = foe_.aspects.get_node("autonomy")
		var damage = -floor(sqrt(attack - defense))
		#print(defense - attack, damage)
		aspect.add_value(damage)
		
		if foe_.dead:
			queue.erase(foe_)
