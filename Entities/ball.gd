extends CharacterBody2D
class_name Ball

signal big_attack_hit
signal small_attack_hit
signal grounded

@export var small_hit_textures : Array[Texture]
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var invince_timer: Timer = $InvinceTimer
@onready var small_hit: AudioStreamPlayer = $SmallHit
@onready var big_hit: AudioStreamPlayer = $BigHit
@onready var big_hit_ball_particle : GPUParticles2D = $BigHitBallParticle
@onready var small_hit_ball_particle : GPUParticles2D = $SmallHitBallParticle
@onready var ray: RayCast2D = $RayCast2D
@onready var ground_timer: Timer = $GroundTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var distortion_rect: ColorRect =$"../Shaders/Distortion"

const HIT = preload("uid://bgmg7qe01dlaf")
var SPEED = 135.0
const JUMP_VELOCITY = -150.0
var ACCEL = 500.0 
const  FRICT = 800.0


var jumped := false
var wasOnFloor := false
var coyote := false


var direction = 0
var lastDir = 1

var gravity = 700

var juggle_grav = 400
var throw_grav = 750

var friction = 1000
var air_res = 35

var has_been_grounded := true

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_floor():
		#velocity.x = move_toward(velocity.x, 0.0, 1000 * delta)
		if ground_timer.is_stopped():
			ground_timer.start()
		pass
	else:
		has_been_grounded = false
		ground_timer.stop()
		velocity.x = move_toward(velocity.x, 0.0, air_res * delta)
	
	##if is_on_floor():
		##velocity.x += Input.get_axis("otherleft", "otherright") * 500
		##if Input.is_action_just_pressed("otherjump"):
			##velocity.y = -100



func _on_area_2d_area_entered(area: Area2D) -> void:
	if !invince_timer.is_stopped(): return
	invince_timer.start()
	var direction : Vector2
	if area is PlayerAttack:
		if area.global_position.direction_to(global_position).dot(Vector2.UP) < 0.0 and has_been_grounded:
			direction = area.global_position.direction_to(global_position)
		else: 
			
			direction = area.direction
		if area.big_attack:
			Input.start_joy_vibration(0, 0.7, 0.6, 0.2)
			
			big_attack_hit.emit()
			SignalBus.small_pause.emit(0.1)
			SignalBus.noise_shake.emit(32)
			distortion_rect.distort(get_global_transform_with_canvas()[2] + area.direction * 8.0)
			big_hit.play()
			small_hit.play()
			
			velocity = area.direction * 330
			velocity.x *= 0.85
			big_hit_ball_particle.emitting = true
			big_hit_ball_particle.process_material.set_meta("direction", area.direction)
		else:
			Input.start_joy_vibration(0, 0.5, 0.3, 0.1)
			small_attack_hit.emit()
			SignalBus.small_pause.emit(0.05)
			SignalBus.noise_shake.emit(8)
			small_hit.play()
			small_hit_ball_particle.emitting = true
			small_hit_ball_particle.process_material.set_meta("direction", area.direction)
			
			velocity = direction * 275
			
		var h : Node2D = HIT.instantiate()
		h.global_position = global_position
		SignalBus.spawn_effect.emit(h)


func _on_grounded_timer_timeout() -> void:
	pass # Replace with function body.


func _on_ground_timer_timeout() -> void:
	has_been_grounded = true
	grounded.emit()


func _on_coyote_timer_timeout() -> void:
	coyote = false
