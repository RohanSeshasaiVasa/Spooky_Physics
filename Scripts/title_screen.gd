extends CanvasLayer

@onready var menu: Control = $Menu
@onready var how_to_play = $HowToPlay

func _ready() -> void:
	show()
	menu.show()
	how_to_play.hide()
	
func _on_start_button_pressed() -> void:
	hide()

func _on_how_to_play_button_pressed() -> void:
	menu.hide()
	how_to_play.show()
	
func _on_back_button_pressed() -> void:
	how_to_play.hide()
	menu.show()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
