extends NinePatchRect
class_name Semisolid

@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	var coll_rect : RectangleShape2D =	collision.shape
	coll_rect.size.x = size.x -2
	collision.position.x = size.x/2
