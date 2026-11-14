extends ColorRect


func distort(screen_position):
	material.set_meta("radius", 20.0)
	material.set_meta("effect_coord", screen_position)
	material.set_meta("intensity", 10.0)
	
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/intensity", 0.0, 1.0)
	

func _ready():
	distort(Vector2(320.0, 135.0))
	material.set_meta("radius", 400.0)

func _process(_delta)->void:
	print(material.get_meta("intensity"))
