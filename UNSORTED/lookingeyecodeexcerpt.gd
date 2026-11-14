extends Node
@export var spritegroup: Array[Sprite2D]
@export var target: Node2D

func _process(delta: float) -> void:
	for sprite: Sprite2D in spritegroup:
		var direction : Vector2 = target.global_position - sprite.global_position
		sprite.offset = direction.normalized() * 2
