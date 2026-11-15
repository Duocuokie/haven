extends Node2D
class_name Level
@onready var level : Node2D = $Level
@onready var camera: camerMover = $LevelCamera

@onready var smallPauseTimer : Timer = $SmallPause
@onready var effects: Node2D = $Level/Effects


#@onready var player: Player = $Level/Player

func _ready() -> void:
	

	
	#SignalBus.spawn_entity.connect(spawn_entity)
	SignalBus.spawn_effect.connect(spawn_effect)
	
	#SignalBus.spawn_entity_deferred.connect(spawn_entity, true)
	SignalBus.spawn_effect_deferred.connect(spawn_effect, true)
	
	SignalBus.noise_shake.connect(camera.apply_noise_shake)
	SignalBus.small_pause.connect(func(amount : float)->void: call_deferred("smallPause", amount))
	#SignalBus.world_reparent_entity.connect(func(e : Node2D) -> void : e.reparent(entities))
	
	#SignalBus.playerDie.connect(func()->void:
		#Engine.time_scale = 0.1
		#var tween := create_tween()
		#tween.set_ignore_time_scale(true)
		#tween.tween_property(Engine, "time_scale", 1, 2))
	


func smallPause(time : float)  -> void:
	smallPauseTimer.start(time)
	level.process_mode = Node.PROCESS_MODE_DISABLED
	
func smallUnpause()  -> void:
	level.process_mode = Node.PROCESS_MODE_PAUSABLE

func pause()  -> void:
	level.process_mode = Node.PROCESS_MODE_DISABLED
	
func unpause()  -> void:
	level.process_mode = Node.PROCESS_MODE_PAUSABLE

func _unhandled_input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if Input.is_action_just_pressed("ui_page_up"):
		get_tree().reload_current_scene()

#func setCam(room : Room) -> void:
	#var limits : Array = rooms[room.roomID].camLim
	#camera.limit_top = limits[0]
	#camera.limit_right = limits[1]
	#camera.limit_bottom = limits[2]
	#camera.limit_left = limits[3]
	##camera.top_lim = limits[0]
	##camera.right_lim = limits[1]
	##camera.bottom_lim = limits[2]
	##camera.left_lim = limits[3]


func spawn_effect(effect : Node2D, defer := false) -> void:
	if defer: effects.call_deferred("add_child", effect)
	else: effects.add_child(effect)

#func spawn_entity(entity : Node2D, defer := false) -> void:
	#if defer: entities.add_child(entity)
	#else: entities.call_deferred("add_child", entity)

func level_enter() -> void:
	pass
	

func level_exit() -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
