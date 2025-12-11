class_name State

extends Node

var state_machine: StateMachine


func physics_update(_delta: float) -> void:
	pass


func update(_delta: float) -> void:
	pass


func enter(_data := {}) -> void:
	pass


func exit() -> void:
	pass


func is_current_state() -> bool:
	return state_machine.current_state == self
