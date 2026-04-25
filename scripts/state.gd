class_name State

extends Node

var state_machine: StateMachine


func handle_input(_event: InputEvent) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func update(_delta: float) -> void:
	pass


func enter(_data: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass


# No-ops if attempting to transition while not the current state
func transition_to(state_name: String, data: Dictionary = {}) -> void:
	if state_machine.current_state != self:
		return

	state_machine.transition_to(state_name, data)


func is_current_state() -> bool:
	return state_machine.current_state == self
