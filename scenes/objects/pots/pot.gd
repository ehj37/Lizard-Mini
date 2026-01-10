class_name Pot

extends StaticBody2D

const NUM_FRAGMENTS := 3
const MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE := PI / 4
const MIN_IMPULSE_MAGNITUDE := 400.0
const MAX_IMPULSE_MAGNITUDE := 800.0

@onready var fragment_resource := preload("res://scenes/objects/pots/fragment/fragment.tscn")
@onready var dust_puff_resource := preload("res://scenes/objects/pots/dust_puff/dust_puff.tscn")
@onready var hurtbox: Hurtbox = $Hurtbox


func take_damage(_amount: int, _type: Hitbox.DamageType, direction: Vector2):
	_spawn_fragments(direction)
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.POT_BREAK)
	_spawn_dust_puff()

	queue_free()


func _spawn_fragments(direction: Vector2) -> void:
	for i in NUM_FRAGMENTS:
		var fragment = fragment_resource.instantiate() as PotFragment
		var spawn_angle_offset = randf_range(
			-MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE, MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE
		)
		var impulse_magnitude = randf_range(MIN_IMPULSE_MAGNITUDE, MAX_IMPULSE_MAGNITUDE)
		var spawn_direction = direction.rotated(spawn_angle_offset)
		fragment.apply_central_impulse(spawn_direction * impulse_magnitude)
		fragment.global_position = global_position
		owner.add_child(fragment)


func _spawn_dust_puff() -> void:
	var dust_puff = dust_puff_resource.instantiate() as Sprite2D
	dust_puff.global_position = global_position
	owner.add_child(dust_puff)
