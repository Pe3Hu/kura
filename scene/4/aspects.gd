extends HBoxContainer


func _ready() -> void:
	for child in get_children():
		child.update_label_color()
