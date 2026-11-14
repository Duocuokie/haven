extends Line2D

@export var Node_One: Node2D
@export var Node_Two: Node2D
@export var Length = 300

# source: https://www.alanzucconi.com/2020/12/13/catenary-2/
func calculate_points() -> void:
	var segments = get_point_count() - 1 # rope segments is number of points - 1
	var pos_difference = (Node_Two.position - Node_One.position)
	var increment = pos_difference.x/segments
	# local position
	
	var h = pos_difference.x
	var v = pos_difference.y
	var main_node = Node_Two # node two on right
	if h < 0:
		main_node = Node_One # node one on right
		increment *= -1
		h *= -1
		v *= -1
	if Length**2 > (h**2 + v**2):
		var a = 1
		# parametric equation idk
		var step = 1
		while sqrt(Length**2 - v**2) < (2 * a * sinh(h/(2*a))):
			a += step
		# find suitable value for a
		
		var p = (h - a * log((Length + v)/(Length - v)))/2
		var q = (v - Length * (cosh(h/(2*a))/sinh(h/(2*a))))/2
		if v == 0: q = 0
		for i in range(0, segments+1): # ignore starting and ending points
			var x = increment * i
			var y = a * cosh((x-p)/a) - a * cosh(-p/a)
			set_point_position(i, Vector2(-x, -y) + main_node.position)
			# reapply offset
	else:
		for i in range(1, segments+1):
			set_point_position(i, Node_Two.position)
		set_point_position(0, Node_One.position)

func _process(_delta) -> void:
	calculate_points()
