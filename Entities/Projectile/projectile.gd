extends Node2D
class_name Projectile

@export var stats : ProjStats
@onready var hitbox: Hitbox = $Hitbox

@onready var move: moveComponent = $moveComponent
@export var deleteCol: deleteOnCollisionComponent
@export var delete_hitbox : CollisionShape2D

var pierce : int

func  _ready() -> void:
	hitbox.data.damage = stats.damage
	hitbox.data.invis = stats.invis
	hitbox.data.knockback = stats.knockback
	hitbox.data.inflictStatus = stats.inflictStatus
	pierce = stats.pierce
	if deleteCol:
		deleteCol.pierce = pierce


func _on_collision_delay_timeout() -> void:
	delete_hitbox.disabled = false
