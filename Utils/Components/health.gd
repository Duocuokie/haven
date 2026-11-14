extends Node2D
class_name healthComp


@export var maxHealth : int
@onready var health : int = maxHealth : set = setter

signal healthChanged(health : int , maxHealth : int)
signal die

func setter(value : int) -> void:
	health = value
	health = clamp(health, 0 , maxHealth)
	emit_signal("healthChanged", health, maxHealth)
	if health <= 0:
		emit_signal("die")
