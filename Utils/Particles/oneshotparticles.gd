extends GPUParticles2D



func _ready() -> void:
	emitting = true





func _on_finished() -> void:
	if !emitting:
		queue_free()
