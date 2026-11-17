extends Node

@export var target: Node2D
var spritegroup:Array[Node2D]

func _ready():
	for child in get_children():
		if child.has_node("eye"):
			spritegroup.append(child.get_node("eye"))
		if child.has_node("eye2"):
			spritegroup.append(child.get_node("eye2"))

func _process(_delta: float) -> void:
	for sprite: Sprite2D in spritegroup:
		var direction : Vector2 = target.global_position - sprite.global_position
		sprite.offset = direction.normalized() * 3
