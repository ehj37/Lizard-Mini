class_name Hitbox

extends Area2D

signal blood_drawn

# Difference between FIRE and BURN:
# FIRE is intended to impart a burn effect.
# BURN is intended to deal burn damage and impart a burn effect.
# E.g. walking on a fire vent does nothing if the player is already burning.
# Getting hit by a wisp will damage the player even if they're already burning.
enum DamageType { ENEMY, PLAYER, EXPLOSIVE, FIRE, BURN }

@export var damage_amount: int = 100
@export var damage_type: DamageType
@export var grounded := false
@export var disabled := false


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true


func damage_direction(_hurtbox: Hurtbox) -> Vector2:
	return Vector2.ZERO


func on_hurtbox_connect(hurtbox: Hurtbox) -> void:
	if hurtbox.owner is Player || hurtbox.owner is Enemy:
		blood_drawn.emit()
