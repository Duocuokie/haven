extends GPUParticles2D
@onready var camera: camerMover = $"../LevelCamera"

func _process(_delta) -> void:
	if camera:
		position = camera.position + Vector2(320.0, 0.0)
