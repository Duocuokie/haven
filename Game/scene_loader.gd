extends Node2D

@export var transition: Transition
@export var current_scene : Node
@export var main : Node

var current_path : String
var is_loading := false
var load_queue : Array

func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(current_path)
	match status:
		ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(current_path)
			var S : Node = new_scene.instantiate()
			main.add_child(S)
			#if S is Level:
				#S.level_enter()
			current_scene = S
			transition.hide_transition()
			is_loading = false
			set_process(false)

func transition_unloaded_scene(path : String) -> void:
	if is_loading:
		load_queue.append(path)
		return
	transition.show_transition()
	is_loading = true
	await transition.show_finished
	current_path = path
	ResourceLoader.load_threaded_request(path)
	set_process(true)
	#if current_scene is Level:
		#current_scene.level_exit()
	if current_scene:
		current_scene.queue_free()
