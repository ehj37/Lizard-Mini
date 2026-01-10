class_name StateMachine

extends Node

@export var initial_state: State

var current_state: State
var _states: Array[State] = []


func _ready() -> void:
	await owner.ready

	for child: State in get_children():
		assert(child is State)

		child.state_machine = self
		_states.append(child)

	current_state = initial_state
	current_state.enter({})


func transition_to(state_name: String, data := {}) -> void:
	current_state.exit()

	var next_state_i = _states.find_custom(func(state: State): return state.name == state_name)
	assert(next_state_i != -1, "Cannot find state with name " + state_name)

	var next_state = _states[next_state_i]
	current_state = next_state
	current_state.enter(data)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)
