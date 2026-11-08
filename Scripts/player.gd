extends CharacterBody2D

@export var speed: float = 400.0
@export var light_energy: float = 1.2

@onready var flashlight: PointLight2D = $Flashlight
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if direction != Vector2.ZERO:
		flashlight.rotation = lerp_angle(flashlight.rotation, direction.angle(), 0.2)
		
	update_animation(direction)
	
func _process(delta: float) -> void:
	if randf() < 0.001:
		flashlight.energy = randf_range(0.1, 0.5)
	else:
		flashlight.energy = lerpf(flashlight.energy, light_energy, 0.1)

func update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		sprite.stop()
		return
	var facing: String
	if absf(direction.x) > absf(direction.y):
		facing = "right" if direction.x > 0 else "left"
	else:
		facing = "down" if direction.y > 0 else "up"
	sprite.play("walk_" + facing)
