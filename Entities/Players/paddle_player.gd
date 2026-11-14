extends CharacterBody2D
class_name  Player


#@onready var coyoteTimer: Timer = $CoyoteTimer
#@onready var sprite: Sprite2D = $Sprite2D
#@onready var fsm: FSM = $StateMachine
#@onready var playerMoveState: PlayerMoveState = $StateMachine/PlayerMoveState
#@onready var water_detect: Area2D = $WaterDetect
#@onready var camera
@onready var attack_anim: AnimationPlayer = $AttackAnim
@onready var player_attack: Area2D = $PlayerAttack
@onready var player_attack_2: PlayerAttack = $PlayerAttack2
@onready var sprite: Sprite2D = $Sprite2D


var SPEED = 200.0
const JUMP_VELOCITY = -330.0
var ACCEL = 2000.0 
const  FRICT = 1500.0
var gravity = 700

var jumped := false
var wasOnFloor := false
var coyote := false


var direction = 0
var lastDir = 1

var charge = 0
var hold_amount = 0 
var max_charge = 3



#func _ready() -> void:
	#playerMoveState.dive.connect(fsm.change_state.bind(playerDiveState))
	#playerDiveState.move.connect(fsm.change_state.bind(playerMoveState))
	#global_position=Global.checkpoint

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("attack") and charge >= max_charge:
		hold_amount += delta
		Engine.time_scale = lerp(Engine.time_scale, 0.5, 10 * delta)
	else:
		Engine.time_scale = 1.00
		
		
	if Input.is_action_just_released("attack"):
		if charge >= max_charge and hold_amount > 0.2:
			attack_anim.play("attack2")
			player_attack_2.rotation = global_position.angle_to_point(get_global_mouse_position())
			player_attack_2.direction = global_position.direction_to(get_global_mouse_position())
			charge = 0
		else:
			attack_anim.play("attack")
			player_attack.rotation = global_position.angle_to_point(get_global_mouse_position())
			player_attack.direction = global_position.direction_to(get_global_mouse_position())
		hold_amount = 0
		

#func _physics_process(delta: float) -> void:
	#if velocity.x != 0:
		#sprite.rotation_degrees += (velocity.length() * sign(velocity.x) * 0.04)
	#direction = Input.get_axis("ui_left", "ui_right")
	#if direction != 0:
		#if abs(velocity.x) < 280 || direction != sign(velocity.x):
			#velocity.x = move_toward(velocity.x, (direction * SPEED), ACCEL * delta )
			#lastDir = direction
		#else:
			#velocity.x = move_toward(velocity.x, (direction * SPEED), ACCEL/10 * delta )
			#lastDir = direction
	#else:
		#if is_on_floor():
			#velocity.x = move_toward(velocity.x, 0, FRICT * delta)
		#else:
			#velocity.x = move_toward(velocity.x, 0, FRICT * 0.7 * delta)
	#camera.position.x = move_toward(camera.position.x, 96 * direction, 128 * delta)
	#

func _on_coyote_timer_timeout() -> void:
	coyote = false

#
#func _on_hurt_box_area_entered(area: Area2D) -> void:
	#visible = false
	#die.play()
	#die.reparent(get_parent())
	#%DeathTimer.start()
	#%DeathTimer.reparent(get_parent())
	#Global.shake.emit(16)
	#queue_free()
	#queue_free()
	#
	#
	#
	#
#
#
#func _on_death_timer_timeout() -> void:
	#pass # Replace with function body.
#
#
#func _on_hitbox_area_entered(area: Area2D) -> void:
	#playerMoveState.hold_interupt = true
	#if area.top:
		#print("bounce")
		#velocity.y = -500 
	#else:
		#velocity.y = 500 
	#
		#
#
#
#func _on_hurt_box_body_entered(body: Node2D) -> void:
	#visible = false
	#die.play()
	#die.reparent(get_parent())
	#%DeathTimer.start()
	#%DeathTimer.reparent(get_parent())
	#Global.shake.emit(16)
	#queue_free()
#
#
#
#
#
#func _on_water_detect_body_entered(body: Node2D) -> void:
	#print(velocity.y)
	#if velocity.y > 200:
		#%splash.play()


func _on_coyote_timeout() -> void:
	coyote = false
