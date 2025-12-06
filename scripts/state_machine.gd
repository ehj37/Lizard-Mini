class_name StateMachine

extends Node

@export var initial_state: State

var _current_state: State
var _states: Array[State] = []


func _ready() -> void:
	await owner.ready

	for child: State in get_children():
		assert(child is State)

		child.state_machine = self
		_states.append(child)

	_current_state = initial_state
	_current_state.enter({})


func transition_to(state_name: String, data := {}) -> void:
	_current_state.exit()

	var next_state_i = _states.find_custom(func(state: State): return state.name == state_name)
	assert(next_state_i != -1, "Cannot find state with name " + state_name)

	var next_state = _states[next_state_i]
	next_state.enter(data)
	_current_state = next_state


func _physics_process(delta: float) -> void:
	_current_state.physics_update(delta)


func _process(delta: float) -> void:
	_current_state.update(delta)
