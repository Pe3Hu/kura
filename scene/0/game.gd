extends Node


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.node.maze = Global.scene.maze.instantiate()
	#Global.node.game.get_node("Layer0").add_child(Global.node.maze)
	Global.node.arena = Global.scene.arena.instantiate()
	Global.node.game.get_node("Layer0").add_child(Global.node.arena)
	
	for altar in Global.node.arena.altars:
		altar.select_cards()
		#altar.create_servant()
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					pass


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
