extends Node


signal spawn_entity(entity : Node2D)
signal spawn_effect(effect : Node2D)
signal spawn_entity_deferred(entity : Node2D)
signal spawn_effect_deferred(effect : Node2D)
signal world_reparent_entity(entity: Node2D)
signal noise_shake(amount : float)
signal small_pause(time : float)
signal transition_scene(path : String)

signal control_changed
