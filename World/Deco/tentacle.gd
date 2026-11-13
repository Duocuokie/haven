extends Node2D
class_name Tentacle



@export var reset_segments := false
@export var procedual_wrap := false

@export_group("Shadow")
## Subtle shadow at arm base creates depth without overwhelming the visual
@export var min_shadow_offset: Vector2 = Vector2(0, 5)
## Exaggerated shadow at tip emphasizes the arm reaching outward
@export var max_shadow_offset: Vector2 = Vector2(0, 20)
@export var main_arm : Line2D
@export var shadow : Line2D

@export var actor : Node2D

@export var wrap_angle : float = 2*TAU
@export var end_length_offset : float = 0
@export var num_segments := 25
@export var max_length := 250.0
@export var extra_length := 30

var origin : Vector2
var segments : Array = []
var segment_length : float = 20
var segment_lengths : Array[float]

var target : Vector2

func _ready() -> void:
	origin = Vector2(0, 0)
	target = global_position
	main_arm.clear_points()
	segments.append(origin)
	for i in range(num_segments):
		var length : float = max_length/num_segments
		segment_lengths.append(length)
		segments.append(origin + Vector2(length * (i + 1), 0))
	set_segement_lengths()
	




func _physics_process(delta: float) -> void:
	if actor:
		origin = actor.global_position
	if reset_segments: reset_segement_lengths(target, delta)
	#var dist = get_local_mouse_position().length()
	procedual_tentacle(target)
	if procedual_wrap: procedual_tentacle_wrap(target)
	apply_wave_motion(delta)
	procedual_tentacle(target)
	
	main_arm.clear_points()
	for point : Vector2 in segments:
		main_arm.add_point(point)
	if shadow:
		shadow.clear_points()
		for i in range(segments.size()):
			var t: float = float(i) / float(segments.size() - 1)
			var shadow_offset: Vector2 = min_shadow_offset.lerp(max_shadow_offset, t)
			var offset_pos: Vector2 = segments[i] + shadow_offset
			shadow.add_point((offset_pos))


func procedual_tentacle(target_pos : Vector2) -> void:
	segments[-1] = target_pos
	for i in range(num_segments -1, -1, -1):
		var direction : Vector2 = (segments[i] - segments[i+1]).normalized()
		segments[i] = segments[i +1] + direction * segment_lengths[i]
	
	segments[0] = origin
	for i in range(num_segments):
		var direction : Vector2 = (segments[i+1] - segments[i]).normalized()
		segments[i+1] = segments[i] + direction * segment_lengths[i]
		
func procedual_tentacle_wrap(target_pos : Vector2) -> void:
	segments[-1] = target_pos
	var target_dir := (target_pos - origin).normalized()
	var step : float = (wrap_angle)/(num_segments-1)
	for i in range(num_segments -1, -1, -1):
		var direction : Vector2 = (-target_dir).rotated(step *  (1/float(num_segments**1)) * (i**2))
		segments[i] = segments[i +1] + direction * segment_lengths[i]
	
	segments[0] = origin
	#for i in range(num_segments):
		#var direction : Vector2 = (segments[i+1] - segments[i]).normalized()
		#segments[i+1] = segments[i] + direction * segment_lengths[i]

func set_segement_lengths() -> void:
	segment_lengths.clear()
	var length : float = float(max_length)/float(num_segments)
	var mid := int(num_segments/3.0)
	#var sum : int = 0
	for i in range(mid):
		segment_lengths.append((length*1.08)-(length)/(i*0.1+1))
	#	sum += segment_lengths[i]
	for i in range(mid, num_segments):
		segment_lengths.append(length - ((i*length)/(num_segments)) + (length*end_length_offset))
	#	sum += segment_lengths[i]

func reset_segement_lengths(seg_target : Vector2, delta : float) -> void:
	segment_lengths.clear()
	max_length = lerp(max_length, (global_position.distance_to(seg_target)*1.8), delta * 5) + extra_length
	var length : float = float(max_length)/float(num_segments)
	var mid := int(num_segments/3.0)
	for i in range(mid):
		segment_lengths.append((length*1.08)-(length)/(i*0.1+1))
	for i in range(mid, num_segments):
		segment_lengths.append(length - ((i*length)/(num_segments)) + (length*end_length_offset))
@export_group("Wave Motion")
## Perpendicular displacement. Too high destroys the IK targeting, too low looks stiff.
@export_range(0.0, 5.0, 0.5) var wave_amplitude: float = 2.5
## Controls wavelength. Higher values create tighter, more frequent waves along the arm.
@export_range(0.0, 5, 0.1) var wave_frequency: float = 2.0
## Animation speed multiplier. Independent from physics delta for artistic control.
@export_range(0.0, 10.0, 0.1) var wave_speed: float = 3.0
var _wave_time: float = 0.0
func apply_wave_motion(delta: float) -> void:
	# No amplitude, no wave!! (╯°o°）╯︵ ┻━┻
	if wave_amplitude <= 0.0:
		return

	_wave_time += delta * wave_speed

	var total_length: float = 0.0
	for length in segment_lengths:
		total_length += length

	var accumulated_length: float = 0.0
	for i in range(1, segments.size()):
		accumulated_length += segment_lengths[i - 1]

		# Normalized position (0-1) along the arm determines wave phase offset
		var t: float = accumulated_length / total_length

		var vec: Vector2 = segments[i] - segments[i - 1]
		var direction: Vector2 = vec.normalized()
		var perpendicular: Vector2 = direction.orthogonal()

		# Phase combines time (animation) with position (traveling wave) ᶘ ◕ᴥ◕ᶅ
		var wave_phase: float = _wave_time + t * wave_frequency * TAU
		var wave_offset: float = sin(wave_phase) * wave_amplitude
		segments[i] += perpendicular * wave_offset
