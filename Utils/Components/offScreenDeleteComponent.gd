extends VisibleOnScreenNotifier2D
class_name offScreenDelete

@export var actor : Node2D



func _on_screen_exited() -> void:
	actor.queue_free()
