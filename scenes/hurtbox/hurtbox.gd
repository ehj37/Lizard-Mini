class_name Hurtbox

extends Area2D

signal hitbox_connected(damage_direction: Vector2, damage_types: Array[Hitbox.DamageType])
signal burned

enum OwnerType { UNCATEGORIZED, PLAYER, ENEMY }

@export var health_component: HealthComponent
# If the hurtbox's owner has been damaged by a hitbox, the amount of time before
# the hitbox can hurt the hurtbox's owner again.
# Default of 0.1 is oriented to player sword hitbox enable time.
@export var repetitive_hitbox_damage_cooldown: float = 0.1
@export var self_damage_disabled: bool = true
@export var damage_type_immunities: Array[Hitbox.DamageType]
@export var grounded: bool = false
# A fragile hurtbox will cause damage to be taken even if the intersecting
# hitbox imparts 0 damage.
# E.g. the player dash won't hurt an enemy, but might break some pottery.
@export var fragile: bool = false
@export var flammable: bool = false
@export var disabled: bool = false

var _overlapping_hitboxes: Array[Hitbox] = []
var _hitbox_instance_ids_on_cooldown: Array[int] = []


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true


func is_hurt_by(hitbox: Hitbox) -> bool:
	if self_damage_disabled && hitbox.owner == owner:
		return false

	if grounded != hitbox.grounded:
		return false

	if flammable && hitbox.damage_types.has(Hitbox.DamageType.FIRE):
		burned.emit()

	if hitbox.damage_amount <= 0 && !fragile:
		return false

	var relevant_damage_types: Array[Hitbox.DamageType] = hitbox.damage_types.filter(
		func(type: Hitbox.DamageType) -> bool: return !damage_type_immunities.has(type)
	)
	if relevant_damage_types.size() == 0:
		return false

	var hitbox_on_cooldown: bool = _hitbox_instance_ids_on_cooldown.has(hitbox.get_instance_id())
	if hitbox_on_cooldown:
		return false

	return true


func get_owner_type() -> OwnerType:
	if owner is Player:
		return OwnerType.PLAYER

	if owner is Enemy:
		return OwnerType.ENEMY

	return OwnerType.UNCATEGORIZED


func _physics_process(_delta: float) -> void:
	if disabled:
		return

	for hitbox: Hitbox in _overlapping_hitboxes:
		if hitbox.disabled || !is_hurt_by(hitbox):
			continue

		if health_component != null:
			health_component.subtract_health(hitbox.damage_amount)

		hitbox_connected.emit(hitbox.damage_direction(self), hitbox.damage_types)
		hitbox.on_hurtbox_connect(self)

		if repetitive_hitbox_damage_cooldown > 0:
			_add_cooldown_for(hitbox)


func _add_cooldown_for(hitbox: Hitbox) -> void:
	var hitbox_instance_id: int = hitbox.get_instance_id()
	_hitbox_instance_ids_on_cooldown.append(hitbox_instance_id)
	await get_tree().create_timer(repetitive_hitbox_damage_cooldown, false).timeout

	_hitbox_instance_ids_on_cooldown.erase(hitbox_instance_id)


func _on_area_entered(hitbox: Hitbox) -> void:
	_overlapping_hitboxes.append(hitbox)


func _on_area_exited(hitbox: Hitbox) -> void:
	_overlapping_hitboxes.erase(hitbox)
