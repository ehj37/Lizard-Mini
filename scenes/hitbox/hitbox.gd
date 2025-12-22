class_name Hitbox

extends Area2D

signal blood_drawn

@export var damage_amount := 100
@export var damage_direction := Vector2.ZERO
@export var disabled := false


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true


func on_hurtbox_connect(hurtbox: Hurtbox) -> void:
	if hurtbox.owner is Player || hurtbox.owner is Enemy:
		blood_drawn.emit()
