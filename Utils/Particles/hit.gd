extends AnimatedSprite2D
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	play("hit")
	$GPUParticles2D.emitting = true
	$GPUParticles2D.rotation = rng.randf_range(0, 180)
	$GPUParticles2D2.emitting = true
	$GPUParticles2D2.rotation = rng.randf_range(180, 360)
	rotation = rng.randf_range(0, 360)
func _on_animation_finished() -> void:
	queue_free()
