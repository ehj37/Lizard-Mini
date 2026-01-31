class_name Hitbox

extends Area2D

signal blood_drawn(hurtbox_owner_type: HurtboxOwnerType)

# Difference between FIRE and BURN:
# FIRE is intended to impart a burn effect.
# BURN is intended to deal burn damage and impart a burn effect.
# E.g. walking on a fire vent does nothing if the player is already burning.
# Getting hit by a wisp will damage the player even if they're already burning.
enum DamageType { ENEMY, PLAYER, EXPLOSIVE, FIRE, BURN }
enum HurtboxOwnerType { UNCATEGORIZED, PLAYER, ENEMY }

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
	var hurtbox_owner_type: HurtboxOwnerType
	var hurtbox_owner: Node = hurtbox.owner
	if hurtbox_owner is Player:
		hurtbox_owner_type = HurtboxOwnerType.PLAYER
	elif hurtbox_owner is Enemy:
		hurtbox_owner_type = HurtboxOwnerType.ENEMY
	else:
		hurtbox_owner_type = HurtboxOwnerType.UNCATEGORIZED

	blood_drawn.emit(hurtbox_owner_type)
