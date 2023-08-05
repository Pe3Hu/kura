extends MarginContainer


@onready var influences = $Influences


func add_influence(altar_: MarginContainer, value_: int) -> void:
	for influence in influences.get_children():
		if influence.altar == altar_:
			influence.add_influence(value_)
			return
