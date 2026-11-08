extends Interactable 

@export var torque_needed: float = 12.0
@export var distance: float = 0.8

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
		+ "The handle is %.1f m from the hinge. \n\n" % distance
		+ "How much force do you push with ?"
	)
	answer_input.text = ""
	puzzle_ui.show()
	get_tree().paused = true
	answer_input.grab_focus()
	
func open_door() -> void:
	is_open = true
	disable()
	var tween := create_tween()
	tween.tween_property(hinge, "rotation_degrees", 90.0, 0.6) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	ChoreList.finish("Door", true)

func _on_push_button_pressed() -> void:
	var force := answer_input.text.to_float()
	var correct_force := torque_needed / distance
	puzzle_ui.hide()
	get_tree().paused = false
	
	if absf(force - correct_force) < 0.1:
		open_door()
	elif force > correct_force:
		break_door()
	else:
		nudge_door()
	
func nudge_door() -> void:
	var tween := create_tween()
	tween.tween_property(hinge, "rotation_degrees", 20.0, 0.3)
	tween.tween_property(hinge, "rotation_degrees", 0.0, 0.4)

func break_door() -> void:
	is_open = true
	disable()
	$Hinge/Panel/CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween().set_parallel()
	tween.tween_property(hinge, "rotation_degrees", 110.0, 0.25)
	tween.tween_property(hinge, "position", Vector2(8, 40), 0.25)
	tween.tween_property(hinge, "modulate", Color(0.5, 0.5, 0.5), 0.25)
	ChoreList.finish("Door", false)
	JumpScare.play()
