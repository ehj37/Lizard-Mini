class_name StateMachine

extends Node

@export var initial_state: State
@export var log_state_transitions := false

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
	if log_state_transitions:
		print("-----------")
		print("Exiting: " + current_state.name)
	current_state.exit()

	var next_state_i := _states.find_custom(
		func(state: State) -> bool: return state.name == state_name
	)
	assert(next_state_i != -1, "Cannot find state with name " + state_name)

	var next_state := _states[next_state_i]
	current_state = next_state
	if log_state_transitions:
		print("Entering: " + current_state.name)
	current_state.enter(data)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)
