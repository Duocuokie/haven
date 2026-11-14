extends Timer
class_name DeleteOnTimeoutComponent

@export var time : float = 0
@export var actor : Node2D

signal DeleteTimout

func _ready() -> void:
	start(time)

func _on_timeout() -> void:
	DeleteTimout.emit()
	actor.queue_free()
