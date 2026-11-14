extends CharacterBody2D
class_name Ball

signal big_attack_hit
signal small_attack_hit
@onready var invince_timer: Timer = $InvinceTimer
var gravity = 700

var juggle_grav = 500
var throw_grav = 750

var friction = 1000
var air_res = 20

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, 1000 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, air_res * delta)
	if collision:
		var bounce_velocity : Vector2 = velocity.length() * 0.5* (velocity.bounce(collision.get_normal()).normalized())
		velocity = bounce_velocity
	else:
		move_and_slide()



func _on_area_2d_area_entered(area: Area2D) -> void:
	if !invince_timer.is_stopped(): return
	invince_timer.start()
	if area is PlayerAttack:
		if area.big_attack:
			big_attack_hit.emit()
			SignalBus.small_pause.emit(0.1)
			SignalBus.noise_shake.emit(32)
			velocity = area.direction * 330
		else:
			small_attack_hit.emit()
			SignalBus.small_pause.emit(0.05)
			SignalBus.noise_shake.emit(8)
			velocity = area.direction * 280
			
