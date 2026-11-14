extends Area2D
class_name Hitbox

signal hitbox_hit(area : Hurtbox)
signal collisions_handled

@export var data : HitboxData


@export var ignore_self := true

@export_category("Hitbox Raycast")
@export var require_ray : bool = false
@export var rays : Array[RayCast2D]

var is_crit := false

var num_overlap : int = 0
var overlap_count : int = 0


func _ready() -> void:
	if data:
		data.damage = data.base_damage
		data.knockback = data.base_knockback
	pass

func check_area() -> void:
	for area : Area2D in get_overlapping_areas():
		if !area is Hurtbox:
			return
		if data.hit_layer != area.hit_mask:
			return
		if area.get_parent() == get_parent():
			return
		if require_ray:
			# points the ray at the area's collision shape origin
			var has_noncolliding := false
			for ray in rays:
				ray.target_position = area.global_position - ray.global_position
				ray.force_raycast_update()
				if !ray.is_colliding():
					has_noncolliding = true
					break
			if !has_noncolliding:
				return
		hitbox_hit.emit(area)
		area.damage(self)

func _on_area_entered(area: Hurtbox) -> void:
	if data.hit_layer != area.hit_mask:
		return
	if !area is Hurtbox:
		return
	if area.get_parent() == get_parent():
		return
	if !is_crit and area.ignore_non_crits:
		return
	if require_ray:
		# points the ray at the area's collision shape origin
		var has_noncolliding := false
		for ray in rays:
			ray.target_position = area.global_position - ray.global_position
			ray.force_raycast_update()
			if !ray.is_colliding():
				has_noncolliding = true
				break
		if !has_noncolliding:
			return
	hitbox_hit.emit(area)
	area.damage(self)
