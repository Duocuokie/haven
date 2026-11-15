extends State
class_name PlayerMoveState

@export var actor : CharacterBody2D
@export var coyoteTimer : Timer
@export var left = "left"
@export var right = "right"
@export var jump = "jump"
@export var can_jump := true
@export var sprite : Sprite2D
@export var bounce := false
@export var jump_audio : AudioStreamPlayer

@onready var bufferTimer: Timer = $BufferTimer
var direction := 0
var last_dir := 0

var buffer := false
var hold_interupt = false

var accel : int
var big_bounce := false
var was_in_air := false
var prev_pos
var control = Utils.paddle_controller

func _ready():
	SignalBus.control_changed.connect(func():
		control = Utils.paddle_controller
		if actor is Ball:
			control = (control +1) % 2)
	if actor is Ball:
		control = (control +1) % 2
	set_physics_process(false)
	accel = actor.ACCEL
	
func _enter_state() -> void:
	set_physics_process(true)


func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	#var ball : Ball
	#if actor is Ball:
		#ball = actor
		#print(ball.ray.is_colliding())
	var balls : bool= not (actor is Ball and not (actor.is_on_floor() or actor.ray.is_colliding()))
	if actor is Ball and actor.bounce_unlocked:
		if buffer:
			if was_in_air and actor.is_on_floor() and abs(actor.global_position.x - prev_pos.x) < 1:
				actor.velocity.x = 0
				actor.velocity.y = actor.JUMP_VELOCITY * 2
				big_bounce = true
	if not actor.is_on_floor():
		if actor.wasOnFloor && !actor.jumped:
			actor.coyote = true
			coyoteTimer.start()
		actor.wasOnFloor = false
		was_in_air = true
		actor.jumped = false
		if actor.velocity.y < 0:
			actor.gravity = 825
			accel = actor.ACCEL
		else:
			actor.gravity = 1200
			accel = actor.ACCEL * 1.25
		if actor is not Ball:
			actor.velocity.y += actor.gravity * delta
	else:
		if !was_in_air: big_bounce = false
		was_in_air = false
		actor.wasOnFloor = true
		accel = actor.ACCEL * 1.1

	direction = Input.get_axis(Utils.controls[control]["left"], Utils.controls[control]["right"])
	if big_bounce:
		direction = 0
	if direction != 0:
		if !balls:
			accel = actor.ACCEL / 2
		if abs(actor.velocity.x) < actor.SPEED * 1.7 || direction != sign(actor.velocity.x) and not big_bounce:
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), accel * delta )
			last_dir = direction
		elif not big_bounce:
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), accel/10 * delta )
			last_dir = direction
	else:
		if actor.is_on_floor() :
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICT * delta)

	#camera.position.x = move_toward(camera.position.x, 96 * direction, 128 * delta)
	
	if (Input.is_action_just_pressed(Utils.controls[control]["jump"]) || buffer) and can_jump and not big_bounce:
		if actor.is_on_floor() || actor.coyote:
			actor.velocity.y = actor.JUMP_VELOCITY
			if jump_audio:
				jump_audio.play()
			actor.jumped = true
		else:
			if !buffer:
				bufferTimer.start()
				buffer = true
	else:
		if Input.is_action_just_released(Utils.controls[control]["jump"]) && actor.velocity.y < 0 and !big_bounce:
			actor.velocity.y = actor.velocity.y / 2
			
	prev_pos = actor.global_position
	
	if big_bounce and (actor.is_on_floor() or actor.wasOnFloor):
		actor.velocity.x = 0
		actor.move_and_slide()
	else:
		var collision : KinematicCollision2D = actor.move_and_collide(actor.velocity * delta)
		if collision and bounce:
			var bounce_velocity : Vector2 = 0.5* (actor.velocity.bounce(collision.get_normal()))
			actor.velocity = bounce_velocity
		else:
			actor.move_and_slide()
		


func _on_buffer_timer_timeout() -> void:
	buffer = false
