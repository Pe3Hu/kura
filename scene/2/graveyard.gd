extends MarginContainer


@onready var servants = $Servants


func add_servant(servant_: MarginContainer) -> void:
	servant_.get_parent().remove_child(servant_)
	servants.add_child(servant_)
