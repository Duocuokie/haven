extends Node2D

@onready var scene_loader: Node2D = $SceneLoader

@export var current_scene : Node
const WORLD = "res://World/Worldbackackup.tscn"


func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	SignalBus.transition_scene.connect(scene_loader.transition_unloaded_scene)
	scene_loader.transition_unloaded_scene(WORLD)
