extends State
class_name PlayerDieState

@export var actor : PlayerChar
const PLAYERBIGOUCHIEDIED = preload("res://coolstuff/particles/playerbigouchiedied.tscn")

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	SignalBus.PlayerDie.emit(actor)
	set_physics_process(true)
	actor.visible = false
	actor.velocity = Vector2.ZERO

func _exit_state() -> void:
	set_physics_process(false)
	actor.visible = true

func _physics_process(_delta):
	pass
