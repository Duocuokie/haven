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
@onready var bufferTimer: Timer = $BufferTimer
var direction := 0
var last_dir := 0

var buffer := false
var hold_interupt = false

var accel : int

func _ready():
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
	if not actor.is_on_floor():
		if actor.wasOnFloor && !actor.jumped:
			actor.coyote = true
			coyoteTimer.start()
		actor.wasOnFloor = false
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

		actor.wasOnFloor = true
		accel = actor.ACCEL * 1.1
	if balls:
		direction = Input.get_axis(left, right)
	if direction != 0:
		if abs(actor.velocity.x) < actor.SPEED * 1.7 || direction != sign(actor.velocity.x):
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), accel * delta )
			last_dir = direction
			print("ne;pw")
		else:
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), accel/10 * delta )
			last_dir = direction
	else:
		if actor.is_on_floor():
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICT * delta)

	#camera.position.x = move_toward(camera.position.x, 96 * direction, 128 * delta)
			
	if (Input.is_action_just_pressed(jump) || buffer) and can_jump:
		if actor.is_on_floor() || actor.coyote:
			actor.velocity.y = actor.JUMP_VELOCITY
			actor.jumped = true
		else:
			if !buffer:
				bufferTimer.start()
				buffer = true
	else:
		if Input.is_action_just_released(jump) && actor.velocity.y < 0:
			actor.velocity.y = actor.velocity.y / 2
			
	
	var collision : KinematicCollision2D = actor.move_and_collide(actor.velocity * delta)
	if collision and bounce:
		var bounce_velocity : Vector2 = 0.5* (actor.velocity.bounce(collision.get_normal()))
		actor.velocity = bounce_velocity
	else:
		actor.move_and_slide()


func _on_buffer_timer_timeout() -> void:
	buffer = false
