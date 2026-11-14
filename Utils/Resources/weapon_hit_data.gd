extends Resource
class_name HitboxData

@export_category("Hitbox Data")
@export var base_damage : int
var damage : int = base_damage
## the invincibility time given for attacks of this type
@export var invis : float = 0.2
## knockback given
@export var base_knockback : int = 20
var knockback : int = base_knockback

@export var inflictStatus : int = 0

@export_category("Hitbox Collision")
enum hit_layers{PLAYER, ENEMY}
@export var hit_layer : hit_layers

enum hitTypes{PLAYER, STICK, ROCK, SAP, DASH, PARRY, BRICK_STILL, BRICK_MOVING, STRING, ENEMY}
@export var hitType : hitTypes

@export var crit_score := 20
