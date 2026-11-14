extends Node

var paddle_controller = 0
var controls = [
	{
		"left" : "left",
		"right" : "right",
		"jump" : "jump",
		"attack" : "attack"
	},
	{
		"left" : "otherleft",
		"right" : "otherright",
		"jump" : "otherjump",
		"attack" : "otherattack"
		
	}
]
func rotate_around_to(origin : Vector2, target : Vector2, radius : float)-> Vector2:
	return (target - origin).normalized() * radius
	
func spring_1d(pos: float, target: float, velocity: float, stiffness: float, damping: float, delta: float) -> Dictionary:
	var displacement : float = pos - target
	var force : float = -stiffness * displacement - damping * velocity
	velocity += force * delta
	pos += velocity * delta
	return { "value": pos, "velocity": velocity}
