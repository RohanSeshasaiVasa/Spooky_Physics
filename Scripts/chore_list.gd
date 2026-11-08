extends CanvasLayer

@export var ending_delay: float = 3.0

var tasks := {}
var results := {}

@onready var tasks_box: VBoxContainer = %Tasks
@onready var ending: ColorRect = %Ending
@onready var summary: Label = %Summary

func _ready() -> void:
	for label in tasks_box.get_children():
		tasks[str(label.name)] = label.text
	reset()
	
func finish(chore: String, success: bool) -> void:
	results[chore] = success
	var label: Label = tasks_box.get_node(chore)
	if success:
		label.text = "[x]  " + tasks[chore]
		label.modulate = Color(0.6, 1.0, 0.6)
	else:
		label.text = "[!]  " + tasks[chore] + "  (broken)"
		label.modulate = Color(1.0, 0.45, 0.45)
		
	if results.size() == tasks.size():
		var tween := create_tween()
		tween.tween_interval(ending_delay)
		tween.tween_callback(show_ending)
		
func show_ending() -> void:
	var done_right: int = results.values().count(true)
	summary.text = "Chores done right: %d / %d\n" % [done_right, tasks.size()]
	if done_right == tasks.size():
		summary.text += "The house is pleased with you."
	else:
		summary.text += "The house will remember what you broke....."
	ending.show()
	get_tree().paused = true
	
func _on_play_again_button_pressed() -> void:
	reset()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func reset() -> void:
	results.clear()
	ending.hide()
	for label in tasks_box.get_children():
		label.text = "[]  " + tasks[str(label.name)]
		label.modulate = Color.WHITE
