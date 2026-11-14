extends State
class_name PlayerMoveState

@export var actor : CharacterBody2D
@export var coyoteTimer : Timer
@export var sprite : Sprite2D
@onready var bufferTimer: Timer = $BufferTimer
var direction := 0
var last_dir := 0

var buffer := false
var hold_interupt = false



func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)


func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):

	if not actor.is_on_floor():
		if actor.wasOnFloor && !actor.jumped:
			actor.coyote = true
			coyoteTimer.start()
		actor.wasOnFloor = false
		actor.jumped = false
		if actor.velocity.y < 0:
			actor.gravity = 825
			actor.ACCEL = 2000.0 
		else:
			actor.gravity = 1200
			actor.ACCEL = 2500
		actor.velocity.y += actor.gravity * delta
	else:

		actor.wasOnFloor = true
		actor.ACCEL = 2250

	direction = Input.get_axis("left", "right")
	if direction != 0:
		if abs(actor.velocity.x) < 280 || direction != sign(actor.velocity.x):
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), actor.ACCEL * delta )
			last_dir = direction
		else:
			actor.velocity.x = move_toward(actor.velocity.x, (direction * actor.SPEED), actor.ACCEL/10 * delta )
			last_dir = direction
	else:
		if actor.is_on_floor():
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICT * delta)
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICT * 0.7 * delta)
	#camera.position.x = move_toward(camera.position.x, 96 * direction, 128 * delta)
			
	if Input.is_action_just_pressed("jump") || buffer:
		if actor.is_on_floor() || actor.coyote:
			actor.velocity.y = actor.JUMP_VELOCITY
			actor.jumped = true
		else:
			if !buffer:
				bufferTimer.start()
				buffer = true
	else:
		if Input.is_action_just_released("jump") && actor.velocity.y < 0:
			actor.velocity.y = actor.velocity.y / 2
			

	
	actor.move_and_slide()


func _on_buffer_timer_timeout() -> void:
	buffer = false
