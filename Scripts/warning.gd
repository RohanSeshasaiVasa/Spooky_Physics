extends CanvasLayer

func _ready() -> void:
	show()
	get_tree().paused = true

func _on_accept_button_pressed() -> void:
	hide()
	get_tree().paused = false
