class_name Hitbox

extends Area2D

@export var damage_amount := 100
@export var damage_direction := Vector2.ZERO
@export var disabled := false


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true
