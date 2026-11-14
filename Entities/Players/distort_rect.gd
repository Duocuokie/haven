extends ColorRect
var tween

func distort(screen_position):
	material.set_shader_parameter("radius", 70.0)
	material.set_shader_parameter("effect_coord", screen_position)
	material.set_shader_parameter("intensity", 4.8)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(material, "shader_parameter/intensity", 0.0, 0.6)
	print(material.get_shader_parameter("intensity"))

func _process(_delta) ->void:
	print(material.get_shader_parameter("intensity"))
