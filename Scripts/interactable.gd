class_name Interactable
extends Node2D

@export var prompt_text: String = "[E] Interact"

var player_nearby: bool = false
var enabled: bool = true

@onready var prompt: Label = $Prompt
@onready var area: Area2D = $InteractArea

func _ready() -> void:
	prompt.visible = false
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		prompt.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		prompt.visible = enabled

func _unhandled_input(event: InputEvent) -> void:
	if enabled and player_nearby and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interact()

func interact() -> void:
	pass
	
func disable() -> void:
	enabled = false
	prompt.visible = false
