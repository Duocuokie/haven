extends Node2D
class_name PaddleBall

@onready var line: Line2D = $StringLine
@onready var player: Player = $Player
@onready var ball: Ball = $Ball

var max_string_length = 75
var max_string_paddle = 65
var follow_ball = false
enum paddle_state {THROW, STILL, JUGGLE}
var state : paddle_state

func _ready() -> void:
	ball.big_attack_hit.connect(func(): state = paddle_state.THROW)
	ball.small_attack_hit.connect(func(): 
		state = paddle_state.JUGGLE
		player.charge = clamp(player.charge + 1, 0, 3)
		max_string_paddle = 65 + player.charge * 5)
	ball.grounded.connect(func():
		player.charge = 0)
	

func _physics_process(delta: float) -> void:
	var dist := player.global_position.distance_to(ball.global_position)
	
	if ball.velocity.length() < 30 and state == paddle_state.THROW:
		state = paddle_state.STILL
	if ball.velocity.length() < 50 and state == paddle_state.JUGGLE and ball.is_on_floor():
		state = paddle_state.STILL
	if state == paddle_state.THROW:
		ball.gravity = ball.throw_grav
		if dist > max_string_length:
			var applied_vel := player.global_position.direction_to(ball.global_position) * (40* dist - 4 * player.velocity.length()) * delta
			player.velocity += Vector2(applied_vel.x, applied_vel.y *0.8)
			var ball_applied_vel := ball.global_position.direction_to(player.global_position) * (7* dist - 4 * ball.velocity.length()) * delta
			ball.velocity += Vector2(ball_applied_vel.x, ball_applied_vel.y *0.8)
			player.sprite.rotation = lerp(player.sprite.rotation, player.global_position.direction_to(ball.global_position).angle(), 5 * delta)
	elif state == paddle_state.JUGGLE:
		ball.gravity = ball.juggle_grav
		if dist > max_string_paddle:
			#var applied_vel := player.global_position.direction_to(ball.global_position) * 200 * delta
			#player.velocity += Vector2(applied_vel.x, applied_vel.y *0.8)
			var ball_applied_vel := ball.global_position.direction_to(player.global_position) * (22* dist - 3 * ball.velocity.length()) * delta
			if ball_applied_vel.y > 0:
				ball_applied_vel.y *= 0.70
				ball_applied_vel.x *= 1.3
			else: 
				ball_applied_vel.y *= 1.1
			ball.velocity += Vector2(ball_applied_vel.x, ball_applied_vel.y)
	elif state == paddle_state.STILL:
		ball.gravity = ball.throw_grav
		
		if dist > max_string_length:
			var applied_vel := player.global_position.direction_to(ball.global_position) * (35* dist - 3 * player.velocity.length()) * delta
			player.velocity += Vector2(applied_vel.x, clamp(applied_vel.y *0.8, -10000, 45))
			var ball_applied_vel := ball.global_position.direction_to(player.global_position) *  (7* dist - 4 * ball.velocity.length())  * delta
			ball.velocity += Vector2(ball_applied_vel.x, ball_applied_vel.y *0.8)
