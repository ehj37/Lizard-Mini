class_name Hitbox

extends Area2D

signal blood_drawn(hurtbox_owner_type: Hurtbox.OwnerType, is_lethal: bool)

enum DamageType { ENEMY, PLAYER, EXPLOSIVE, FIRE }

@export var damage_amount: int = 1
@export var damage_types: Array[DamageType] = []
@export var grounded: bool = false
@export var disabled: bool = false

var _overlapping_hurtboxes: Array[Hurtbox]


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true


func damage_direction(_hurtbox: Hurtbox) -> Vector2:
	return Vector2.ZERO


# Returns the number of overlapping hurtboxes that would be damaged by this
# hitbox.
func preview_hit_count() -> int:
	var relevant_hurtboxes: Array[Hurtbox] = _overlapping_hurtboxes.filter(
		func(hurtbox: Hurtbox) -> bool: return !hurtbox.disabled && hurtbox.is_hurt_by(self)
	)
	return relevant_hurtboxes.size()


func on_hurtbox_connect(hurtbox: Hurtbox) -> void:
	if hurtbox.health_component:
		var hurtbox_owner_type: Hurtbox.OwnerType = hurtbox.get_owner_type()
		var is_lethal: bool = hurtbox.health_component.is_health_depleted()
		blood_drawn.emit(hurtbox_owner_type, is_lethal)


func _ready() -> void:
	assert(
		damage_types.size() > 0,
		"Hitbox owned by" + str(owner) + "must specify at least one damage type"
	)


func _on_area_entered(hurtbox: Hurtbox) -> void:
	_overlapping_hurtboxes.append(hurtbox)


func _on_area_exited(hurtbox: Hurtbox) -> void:
	_overlapping_hurtboxes.erase(hurtbox)
