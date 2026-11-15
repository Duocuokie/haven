extends Control


var open = false
var tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		open = not open
		if tween:
			tween.kill()
		tween = create_tween()
		tween.set_trans(Tween.TransitionType.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN_OUT)
		if open:
			tween.tween_property(self, "position", Vector2(0.0,0.0), 0.8)
		else:
			tween.tween_property(self, "position", Vector2(0.0,-360.0), 0.8)


const WORLD = "uid://dk0hrdk1b4hwl"

func _on_restart_pressed() -> void:
	SignalBus.transition_scene.emit(WORLD)
	open = not open
	tween = create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	if open:
		tween.tween_property(self, "position", Vector2(0.0,0.0), 0.8)
	else:
		tween.tween_property(self, "position", Vector2(0.0,-360.0), 0.8)
