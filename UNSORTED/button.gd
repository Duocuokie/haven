extends Button

var state = false
var mouse_on = false
var pos = Vector2.ZERO

func update_sprite():
	if state:
		pos.x = 64
	else:
		pos.x = 0
	if mouse_on:
		pos.y = 64
	else:
		pos.y = 0
	icon.set("region", Rect2(pos, Vector2(64.0, 64.0)))
	

func _on_toggled(toggled_on: bool) -> void:
	state = toggled_on
	update_sprite()
	if toggled_on:
		Utils.paddle_controller = 1
	else:
		Utils.paddle_controller = 0

func _on_mouse_entered() -> void:
	mouse_on = true
	update_sprite()

func _on_mouse_exited() -> void:
	mouse_on = false
	update_sprite()
