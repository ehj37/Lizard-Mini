class_name FragmentSpawner

extends Node2D

const MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE := PI / 4
const MIN_IMPULSE_MAGNITUDE := 400.0
const MAX_IMPULSE_MAGNITUDE := 800.0

@export var fragment_config: FragmentConfig
@export var num_fragments := 3

@onready var _fragment_resource := preload("res://scenes/fragment/fragment.tscn")


func spawn_fragments(direction: Vector2) -> void:
	for i in num_fragments:
		var fragment: Fragment = _fragment_resource.instantiate()
		fragment.fragment_config = fragment_config
		var spawn_angle_offset := randf_range(
			-MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE, MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE
		)
		fragment.global_position = global_position
		(func() -> void: LevelManager.current_level.add_child(fragment)).call_deferred()

		var impulse_magnitude := randf_range(MIN_IMPULSE_MAGNITUDE, MAX_IMPULSE_MAGNITUDE)
		var spawn_direction: Vector2
		if direction == Vector2.ZERO:
			spawn_direction = Vector2.from_angle(randf_range(0.0, 2.0 * PI))
		else:
			spawn_direction = direction.rotated(spawn_angle_offset)
		fragment.apply_central_impulse(spawn_direction * impulse_magnitude)
