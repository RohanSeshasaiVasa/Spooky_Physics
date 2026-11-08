extends Interactable

@export var torque_needed: float = 4.0
@export var distance: float = 0.4

var is_open: bool = false

@onready var hinge: Node2D = $Hinge
@onready var puzzle_ui: CanvasLayer = $PuzzleUI
@onready var question: Label = %Question
@onready var answer_input: LineEdit = %AnswerInput


func interact() -> void:
	if is_open:
		return
	question.text = (
		"The rusty hinges need %.1f Nm of torque.\n" % torque_needed
		+ "You pull at the front edge, %.1f m from the hinge. \n\n" % distance
		+ "How much force do you pull with ?"
	)
	answer_input.text = ""
	puzzle_ui.show()
	get_tree().paused = true
	answer_input.grab_focus()
	
func open_lid() -> void:
	is_open = true
	disable()
	var tween := create_tween()
	tween.tween_property(hinge, "scale:y", 0.15, 0.5) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	ChoreList.finish("Commode", true)

func _on_push_button_pressed() -> void:
	var force := answer_input.text.to_float()
	var correct_force := torque_needed / distance
	puzzle_ui.hide()
	get_tree().paused = false
	
	if absf(force - correct_force) < 0.1:
		open_lid()
	elif force > correct_force:
		break_lid()
	else:
		nudge_lid()
	
func nudge_lid() -> void:
	var tween := create_tween()
	tween.tween_property(hinge, "scale:y", 0.75, 0.25)
	tween.tween_property(hinge, "scale:y", 1.0, 0.3) \
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT) 
		
func break_lid() -> void:
	is_open = true
	disable()
	
	var tween := create_tween().set_parallel()
	tween.tween_property(hinge, "position", hinge.position + Vector2(40, 70), 0.35)
	tween.tween_property(hinge, "rotation_degrees", 200.0, 0.35)
	tween.tween_property(hinge, "modulate", Color(0.5, 0.5, 0.5), 0.35)
	ChoreList.finish("Commode", false)
	JumpScare.play()
