extends Node
class_name FSM

@export var state: State

func _ready() -> void:
	change_state(state)

func change_state(new_state: State) -> void:
	if state is State:
		if state is EnemyDie: return
		state._exit_state()
	new_state._enter_state()
	state = new_state
