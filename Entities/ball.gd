extends CharacterBody2D
class_name Ball

signal big_attack_hit
signal small_attack_hit
@onready var invince_timer: Timer = $InvinceTimer
@onready var small_hit: AudioStreamPlayer = $SmallHit
@onready var big_hit: AudioStreamPlayer = $BigHit
@onready var big_hit_ball_particle : GPUParticles2D = $BigHitBallParticle
@onready var small_hit_ball_particle : GPUParticles2D = $SmallHitBallParticle
const HIT = preload("uid://bgmg7qe01dlaf")

var SPEED = 100.0
const JUMP_VELOCITY = -150.0
var ACCEL = 2000.0 
const  FRICT = 1500.0


var jumped := false
var wasOnFloor := false
var coyote := false


var direction = 0
var lastDir = 1

var gravity = 700

var juggle_grav = 450
var throw_grav = 750

var friction = 1000
var air_res = 35

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if is_on_floor():
		#velocity.x = move_toward(velocity.x, 0.0, 1000 * delta)
		pass
	else:
		velocity.x = move_toward(velocity.x, 0.0, air_res * delta)
	if collision:
		var bounce_velocity : Vector2 = 0.5* (velocity.bounce(collision.get_normal()))
		velocity = bounce_velocity
	else:
		move_and_slide()
	##if is_on_floor():
		##velocity.x += Input.get_axis("otherleft", "otherright") * 500
		##if Input.is_action_just_pressed("otherjump"):
			##velocity.y = -100



func _on_area_2d_area_entered(area: Area2D) -> void:
	if !invince_timer.is_stopped(): return
	invince_timer.start()
	if area is PlayerAttack:
		if area.big_attack:
			big_attack_hit.emit()
			SignalBus.small_pause.emit(0.1)
			SignalBus.noise_shake.emit(32)
			big_hit.play()
			small_hit.play()
			
			velocity = area.direction * 330
			velocity.x *= 0.85
			big_hit_ball_particle.emitting = true
			
		else:
			small_attack_hit.emit()
			SignalBus.small_pause.emit(0.05)
			SignalBus.noise_shake.emit(8)
			small_hit.play()
			small_hit_ball_particle.emitting = true
			small_hit_ball_particle.process_material.set_meta("direction", area.direction)
			
			velocity = area.direction * 275
			
		var h : Node2D = HIT.instantiate()
		h.global_position = global_position
		SignalBus.spawn_effect.emit(h)


func _on_grounded_timer_timeout() -> void:
	pass # Replace with function body.
