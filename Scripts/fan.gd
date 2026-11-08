extends Interactable

@export var start_speed: float = 2.0
@export var target_speed: float  = 14.0
@export var spin_up_time: float = 4.0

var is_done: bool = false
var spin_speed: float = 0.0
var wobbling: bool = false

@onready var blades: Sprite2D = $Blades
@onready var puzzle_ui: CanvasLayer = $PuzzleUI
@onready var question: Label = %Question
@onready var answer_input: LineEdit = %AnswerInput


func _ready() -> void:
	super()
	spin_speed = start_speed
	
func _process(delta: float) -> void:
	blades.rotation += spin_speed * delta
	if wobbling:
		var shake := 2.0 * spin_speed / target_speed
		blades.position = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))

func interact() -> void:
	if is_done:
		return
	question.text = (
		"The fan creaks round at %.1f rad/s.\n" % start_speed
		+ "It must reach %.1f rad/s in %.1f s.\n\n" % [target_speed, spin_up_time]
		+ "What angular acceleration do you set ????????"
	)
	answer_input.text = ""
	puzzle_ui.show()
	get_tree().paused = true
	answer_input.grab_focus()
												
func _on_push_button_pressed() -> void:
	var alpha := answer_input.text.to_float()
	var correct_alpha := (target_speed - start_speed) / spin_up_time
	
	puzzle_ui.hide()
	get_tree().paused = false
	disable()
	
	var final_speed := start_speed + alpha * spin_up_time
	var tween := create_tween()
	tween.tween_property(self, "spin_speed", final_speed, spin_up_time)
	
	if absf(alpha - correct_alpha) < 0.05:
		is_done = true
		tween.tween_callback(ChoreList.finish.bind("Fan", true))
	elif alpha > correct_alpha:
		wobbling = true
		tween.tween_callback(fly_off)
	else:
		tween.tween_interval(0.5)
		tween.tween_property(self, "spin_speed", start_speed, 2.0)
		tween.tween_callback(allow_retry)
		
func fly_off() -> void:
	wobbling = false
	is_done = true
	JumpScare.play()
	
	var tween := create_tween().set_parallel()
	tween.tween_property(blades, "position", Vector2(50, 60), 0.5)
	tween.tween_property(blades, "scale", Vector2(0.8, 0.8), 0.5)
	tween.tween_property(blades, "modulate", Color(0.5, 0.5, 0.5), 0.5)
	tween.tween_property(self, "spin_speed", 0.0, 0.8)
	
	ChoreList.finish("Fan", false)

func allow_retry() -> void:
	enabled = true
	prompt.visible = player_nearby
