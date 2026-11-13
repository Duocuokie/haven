extends Node2D

@onready var scene_loader: Node2D = $SceneLoader

@export var current_scene : Node
const WORLD = "uid://dk0hrdk1b4hwl"


func _ready() -> void:
	SignalBus.transition_scene.connect(scene_loader.transition_unloaded_scene)
	scene_loader.transition_unloaded_scene(WORLD)
