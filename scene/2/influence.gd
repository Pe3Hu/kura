extends MarginContainer


@onready var progress = $ProgressBar

var altar = null
var pillar = null


func add_influence(value_: int) -> void:
	progress.value += value_
	
	if progress.value > progress.max_value:
		progress.value = progress.max_value
