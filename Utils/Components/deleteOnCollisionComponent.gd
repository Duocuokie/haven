extends Node2D
class_name deleteOnCollisionComponent

@export var actor : Node2D
@export var hitbox : Hitbox
@export var area : Area2D
@export var pierce : int 

## deletes actor when a body is contacts. Mainly used for world collisions on layer 1.
@export var body_delete : bool = true

func _ready() -> void:
	if hitbox != null:
		hitbox.hitbox_hit.connect(updatePierce)
		if body_delete:
			hitbox.body_entered.connect(world_collision)
	if area != null:
		area.body_entered.connect(updatePierce)
		area.area_entered.connect(updatePierce)
		



func updatePierce(_area : Node2D) -> void:
	if actor.pierce <= 0:
		if hitbox:
			hitbox.set_deferred("monitoring", false)
		actor.call_deferred("queue_free")
	#pierce -= 1

func world_collision(_unused : Object) -> void:
	hitbox.set_deferred("monitoring", false)
	actor.call_deferred("queue_free")
