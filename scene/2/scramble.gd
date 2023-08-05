extends MarginContainer


var queue = []
var end = null


func start() -> void:
	end = false
	set_servant_queue()
	queue_up()


func set_servant_queue() -> void:
	var datas = {}
	var keys = ["dominances"]
	
	if get_parent().rope == null:
		keys.append("obediences")
	
	for key in keys:
		for altar in get_parent().get(key):
			var squad = get_parent().get(key)[altar]
			
			for servant in squad.servants.get_children():
				var velocity = servant.get_aspect_value("velocity")
				
				if !datas.has(velocity):
					datas[velocity] = []
				
				var data = {}
				data.index = servant.index
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
	if check_foe(servant_.altar):
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
	return datas.front().servant


func press(servant_: MarginContainer, foe_: MarginContainer) -> void:
	var max = {}
	max.servant = servant_.get_aspect_value("power")
	Global.rng.randomize()
	var attack = Global.rng.randi_range(0, max.servant)
	max.foe = foe_.get_aspect_value("autonomy")
	Global.rng.randomize()
	var defense = Global.rng.randi_range(0, max.foe)
	
	print([attack, defense, max])
	
	if attack > defense:
		var aspect = foe_.aspects.get_node("autonomy")
		var damage = defense - attack
		aspect.add_value(damage)
		
		if foe_.dead:
			queue.erase(foe_)
