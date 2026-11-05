extends CharacterBody2D

@export var speed: float = 400.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
