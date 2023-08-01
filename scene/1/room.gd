extends Polygon2D


var ring = null
var maze = null
var backdoor = false
var order = null
var doors = {}


func _ready() -> void:
	init_vertexs()


func init_vertexs() -> void:
	var n = 4
	var vertexs = []
	var angle = PI * 2 / n
	
	for _i in n:
		var vertex = Vector2().from_angle(angle * _i) * Global.num.room.r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func update_color_based_on_ring() -> void:
	if !backdoor:
		var max_h = 360.0
		var s = 0.75
		var v = 1
		var h = 0
		var odd = ring % 6
		
		match odd:
			0:
				h = 0 / max_h
			1:
				h = 210 / max_h
			2:
				h = 120 / max_h
			3:
				h = 270 / max_h
			4:
				h = 300 / max_h
			5:
				h = 60 / max_h
		
		var color_ = Color.from_hsv(h, s, v)
		set_color(color_)


func paint_white() -> void:
	set_color(Color.WHITE)
