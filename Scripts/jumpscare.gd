extends CanvasLayer

@onready var face: TextureRect = $Face
@onready var scream: AudioStreamPlayer = $Scream

func play() -> void:
	face.modulate.a = 1.0
	face.position = Vector2.ZERO
	face.pivot_offset = face.size/2
	face.scale = Vector2(0.5, 0.5)
	show()
	scream.play()
	
	var tween 
