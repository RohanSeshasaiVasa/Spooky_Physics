extends Interactable

const SPOTS := {"A": -0.3, "B": -0.2, "C": -0.1, "D": 0.1, "E": 0.2, "F": 0.3}

@export var hand_force: float = 50.0
@export var couple_needed: float = 30.0

var is_done: bool = false
var picked: Array = []

@onready var brace: Sprite2D = $Brace
@onready var puzzle_ui: CanvasLayer = $PuzzleUI
@onready var question: Label = %Question
@onready var feedback: Label = %Feedback
@onready var spots: Control = %Spots

func _ready() -> void:
	super()
	for button in spots.get_children():
		button.pressed.connect(_on_spot_pressed.bind(button))
		
		
func interact() -> void:
	if is_done:
		return
	question.text = (
		"The rusty nut needs a couple of %.0f Nm to loosen.\n" % couple_needed
		+ "Each hand pushes with %.0f N: one up, one down.\n\n" % hand_force
		+ "Click two spots to place your hands."
	)
	feedback.text = ""
	reset_spots()
	puzzle_ui.show()
	get_tree().paused = true
		
func _on_spot_pressed(button: Button) -> void:
	button.disabled = true
	picked.append(button)
	if picked.size() == 2:
		check_hands()
		
func check_hands() -> void:
	var first: float = SPOTS[str(picked[0].name)]
	var second: float = SPOTS[str(picked[1].name)]
	var d := absf(first - second)
	var couple := hand_force * d
	
	if couple >= couple_needed - 0.01:
		puzzle_ui.hide()
		get_tree().paused = false
		loosen_nut()
	else:
		feedback.text = (
			"d = %.1f m, so couple = %.0f x %.1f = %.0f Nm.\n" % [d, hand_force, d, couple]
			+ "Not enough to turn the nut !! Try again !"
		)
		reset_spots()
		
func reset_spots() -> void:
	picked.clear()
	for button in spots.get_children():
		button.disabled = false
		
func _on_back_button_pressed() -> void:
	puzzle_ui.hide()
	get_tree().paused = false
	
func loosen_nut() -> void:
	is_done = true
	disable()
	var tween := create_tween()
	tween.tween_property(brace, "rotation_degrees", -720.0, 1.2) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
