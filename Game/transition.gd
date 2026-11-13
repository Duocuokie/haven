extends CanvasLayer
class_name Transition

signal hide_finished
signal show_finished

@onready var trans_1: Sprite2D = $Trans1
@onready var trans_2: Sprite2D = $Trans2

var tween_1 : Tween
var tween_2 : Tween

var hide_call := Callable(self, "emit_hide_fin")
var show_call := Callable(self, "emit_show_fin")

var shader_property := "dissolve_value"


func emit_hide_fin() -> void:
	hide_finished.emit()

func emit_show_fin() -> void:
	show_finished.emit()



func show_transition() -> void:
	if tween_1:
		tween_1.kill()
	tween_1 = create_tween()
	tween_1.tween_property(trans_1.material, "shader_parameter/" + shader_property, 1.0, 0.75)
	if tween_2:
		tween_2.kill()
	tween_2 = create_tween()
	tween_2.tween_property(trans_2.material, "shader_parameter/" + shader_property, 1.0, 0.5)
	if tween_2.is_connected("finished", hide_call):
		tween_2.disconnect("finished", hide_call)
	tween_1.finished.connect(show_call)

func hide_transition() -> void:
	if tween_1:
		tween_1.kill()
	tween_1 = create_tween()
	tween_1.set_ease(Tween.EASE_OUT)
	tween_1.set_trans(Tween.TRANS_QUAD)
	tween_1.tween_property(trans_1.material, "shader_parameter/" + shader_property, 0.0, 0.5)
	if tween_2:
		tween_2.kill()
	tween_2 = create_tween()
	tween_2.set_ease(Tween.EASE_OUT)
	tween_2.set_trans(Tween.TRANS_QUAD)
	tween_2.tween_property(trans_2.material, "shader_parameter/" + shader_property, 0, 0.75)
	
	
	if tween_1.is_connected("finished", show_call):
		tween_1.disconnect("finished", show_call)
	tween_2.finished.connect(hide_call)
