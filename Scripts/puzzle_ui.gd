extends CanvasLayer

func _ready() -> void:
	var answer_input := get_node_or_null('%AnswerInput') as LineEdit
	if answer_input:
		answer_input.text_submitted.connect(on_answer_submitted)
		
func on_answer_submitted(_text: String) -> void:
	owner._on_push_button_pressed()

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false
