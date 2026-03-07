@tool

class_name HealthComponent

extends Node

signal health_added(amount: int)
signal health_subtracted(amount: int)
signal health_depleted

@export_range(1, 999, 1) var max_health: int:
	set(new_value):
		max_health = new_value
		if current_health > max_health:
			push_warning("Max health set to below current health—dropping current health down.")
			current_health = max_health

@export_range(1, 999, 1) var current_health: int:
	set(new_value):
		if new_value > max_health:
			push_error("Cannot set current health to a value above max_health, no-op.")
			return

		current_health = new_value


func _ready() -> void:
	# Having a weird time with doing something like:
	# @export_range(1, 999, 1) var max_health: int = 1
	# … and trying to configure an enemy with one health.
	# Seems like a known thing? Potentially the same as issue #75555.
	if max_health == 0:
		max_health = 1

	if current_health == 0:
		current_health = 1


func add_health(amount: int) -> void:
	var pre_add_health: int = current_health
	var post_add_health: int = min(current_health + amount, max_health)
	current_health = post_add_health
	health_added.emit(post_add_health - pre_add_health)


func subtract_health(amount: int) -> void:
	var pre_sub_health: int = current_health
	var post_sub_health: int = max(current_health - amount, 0)
	current_health = post_sub_health
	health_subtracted.emit(pre_sub_health - post_sub_health)

	if current_health == 0:
		health_depleted.emit()
