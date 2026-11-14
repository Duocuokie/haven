extends State
class_name PlayerIdle


@export var player : Player
@export var sprite : Node2D
@export var animTree : AnimationTree

signal runningtime

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	player.global_position = player.global_position.snapped(Vector2(1, 1))

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta : float) -> void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, player.friction * delta)
	player.AnimTreeState.travel("Idle")
	var inputVector := Vector2.ZERO
	inputVector = Input.get_vector("left", "right", "up","down")
	if inputVector != Vector2.ZERO:
		emit_signal("runningtime")
	player.move_and_slide()
	if player.velocity.length() < 16:
		player.global_position = player.global_position.snapped(Vector2(1, 1))
