extends MarginContainer


@onready var bg = $BG
@onready var title = $VBox/Title
@onready var protocols = $VBox/Protocols

var card = null
var type = null
var sockets = 1


func apply_protocol(protocol_: MarginContainer) -> void:
	protocol_.granule = self
	protocols.add_child(protocol_)
	protocol_.update()
