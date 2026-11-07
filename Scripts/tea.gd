extends Interactable

const PIXELS_PER_METRE := 40.0

@export var friction: float = 2.0
@export var distance: float = 4.0

var is_done: bool = false
var cup_start: Vector2
@onready var cup: Sprite2D = $Cup
@onready var ghost: Sprite2D = $Ghost
@onready var puzzle_ui: CanvasLayer = $PuzzleUI
@onready var question: Label = %Question
@onready var answer_input: LineEdit = %AnswerInput

func _ready() -> void:
	super()
	cup_start = cup.position
	var bob := create_tween().set_loops()
	bob.tween_property(ghost, "position:y", ghost.position.y - 3, 1.0).set_trans(Tween.TRANS_SINE)
	bob.tween_property(ghost, "position:y", ghost.position.y, 1.0).set_trans(Tween.TRANS_SINE)

func interact() -> void:
	if is_done:
		return
	question.text = (
		"Friction slows down the cup by %.1f m/s square.\n" %friction
		+ "The ghost is %.1f m away, at the end of the table.\n\n" %distance
		+ "How fast must you slide it so it stops right in front of it ??"
	)
	answer_input.text = ""
	puzzle_ui.show()
	get_tree().paused = true
	answer_input.grab_focus()

func _on_push_button_pressed() -> void:
	var speed := maxf(answer_input.text.to_float(), 0.0)
	var correct_speed := sqrt(2.0 * friction * distance)
	
	puzzle_ui.hide()
	get_tree().paused = false
	disable()
	
	if absf(speed - correct_speed) < 0.1:
		slide(speed).tween_callback(serve_tea)
	elif speed > correct_speed:
		fly_off_table()
	else:
		var tween := slide(speed)
		tween.tween_interval(0.6)
		tween.tween_property(cup, "position", cup_start, 0.5)
		tween.tween_callback(allow_retry)

func slide(speed: float) -> Tween:
	var stop_distance := speed * speed / (2.0 * friction)
	var stop_time := speed / friction
	var stop_x := cup_start.x + stop_distance * PIXELS_PER_METRE
	var tween := create_tween()
	tween.tween_property(cup, "position:x", stop_x, stop_time) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	return tween
	

func serve_tea() -> void:
	is_done = true
	var tween := create_tween().set_parallel()
	tween.tween_property(ghost, "modulate:a", 0.0, 1.5)
	tween.tween_property(cup, "modulate:a", 0.0, 1.5)
	
func fly_off_table() -> void:
	is_done = true
	var tween = create_tween()
	tween.tween_property(cup, "position:x", cup_start.x + 216, 0.5)
	tween.tween_property(cup, "scale", Vector2(0.6, 0.6), 0.2)
	tween.tween_callback(JumpScare.play)
	tween.tween_property(cup, "modulate:a", 0.0, 0.3)

func allow_retry() -> void:
	enabled = true
	prompt.visible = player_nearby
