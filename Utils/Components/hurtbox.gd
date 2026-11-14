extends Area2D
class_name  Hurtbox


var invis := false
var delay := 0.0
var has_delayed := false
var timers : Dictionary[int, Timer]
var damage_mult := 1.0
@onready var invinc_timer : Timer = $Timer
@onready var collision: CollisionShape2D = $CollisionShape2D

@export_category("Node Paths")

@export var health : healthComp

@export var shake : CMPShake
@export var hitshake : int = 0

@export var critshake : int = 0

var hurterPos : Vector2
enum hit_masks{PLAYER, ENEMY}



@export var hit_mask : hit_masks
@export var ignore_non_crits := false

func _ready() -> void:
	health.die.connect(_on_health_die)



signal invisStart
signal invisEnd
signal hurtboxHit(hitbox : Hitbox)
signal hurtboxActivated(hitbox : Hitbox)

func startInvis(duration : float) -> void:
	invis = true
	invinc_timer.start(duration)

func _on_Timer_timeout() -> void:
	invis = false
	has_delayed = true
	if has_overlapping_areas():
		for area:Area2D in get_overlapping_areas():
			if area is Hitbox:
				area._on_area_entered(self)
	has_delayed = false

func _on_health_die() -> void:
	set_deferred("monitorable", false)

func damage(area : Hitbox) -> void:
	if invis:
		return
	if ignore_non_crits and !area.is_crit:
		return
	elif delay > 0.0 && invinc_timer.time_left == 0 && !has_delayed && area.get_parent() is not Projectile:
		startInvis(delay)
		invis = true
		return
	hurtboxHit.emit(area)
	var isNewTimer : bool = false
	var h_data : HitboxData= area.data
	#sets new timer
	if h_data.hitType not in timers:
		isNewTimer = true
		var newTimer : Timer = Timer.new()
		add_child(newTimer)
		timers[h_data.hitType] = newTimer
		timers[h_data.hitType].one_shot = true
		timers[h_data.hitType].start(h_data.invis)
		timers[h_data.hitType].timeout.connect(_on_Timer_timeout)
	if timers[h_data.hitType].is_stopped() || isNewTimer:
		var piercing : bool = true
		#projectile logic
		if area.get_parent() is Projectile:
			#piercing
			if area.get_parent().pierce < 0:
				piercing = false
			else:
				area.get_parent().pierce -= 1
				
		hurtboxActivated.emit(area)
		if health.health > 0 && piercing:
			# hit confirmed
			timers[h_data.hitType].start(h_data.invis)
			health.health -= int(h_data.damage * damage_mult)
			%HitAudio.play()
			if area.is_crit:
				SignalBus.crit_hit_enemy.emit(h_data)
			if shake:
				if area.is_crit && critshake != 0:
					shake.apply_noise_shake(critshake)
				elif hitshake != 0:
					shake.apply_noise_shake(hitshake)
