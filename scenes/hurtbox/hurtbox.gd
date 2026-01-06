class_name Hurtbox

extends Area2D

# If the hurtbox's owner has been damaged by a hitbox, the amount of time before
# the hitbox can hurt the hurtbox's owner again.
@export var repetitive_hitbox_damage_cooldown := 0.0
@export var self_damage_disabled := true
@export var grounded := false
@export var fragile := false
@export var disabled := false

var _overlapping_hitboxes: Array[Hitbox] = []
var _hitbox_instance_ids_on_cooldown: Array[int] = []


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(owner.has_method("take_damage"), "Owner of a hurtbox must have implement take_damage")


func enable() -> void:
	disabled = false


func disable() -> void:
	disabled = true


func _process(_delta) -> void:
	if disabled:
		return

	for hitbox in _overlapping_hitboxes:
		if hitbox.disabled:
			continue

		if self_damage_disabled && hitbox.owner == owner:
			continue

		if grounded != hitbox.grounded:
			continue

		if hitbox.damage_amount <= 0 && !fragile:
			continue

		var hitbox_on_cooldown = _hitbox_instance_ids_on_cooldown.has(hitbox.get_instance_id())
		if hitbox_on_cooldown:
			continue

		owner.take_damage(hitbox.damage_amount, hitbox.damage_direction(self))
		hitbox.on_hurtbox_connect(self)

		if repetitive_hitbox_damage_cooldown > 0:
			_add_cooldown_for(hitbox)


func _add_cooldown_for(hitbox: Hitbox) -> void:
	var hitbox_instance_id = hitbox.get_instance_id()
	_hitbox_instance_ids_on_cooldown.append(hitbox_instance_id)
	await get_tree().create_timer(repetitive_hitbox_damage_cooldown).timeout

	_hitbox_instance_ids_on_cooldown.erase(hitbox_instance_id)


func _on_area_entered(area: Area2D) -> void:
	_overlapping_hitboxes.append(area)


func _on_area_exited(area: Area2D) -> void:
	_overlapping_hitboxes.erase(area)
