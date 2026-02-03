class_name Pot

extends StaticBody2D

const NUM_FRAGMENTS := 3
const MAX_SPAWN_ANGLE_OFFSET_MAGNITUDE := PI / 4
const MIN_IMPULSE_MAGNITUDE := 400.0
const MAX_IMPULSE_MAGNITUDE := 800.0

@onready
var _fragment_spawner_resource := preload("res://scenes/fragment_spawner/fragment_spawner.tscn")
@onready var _fragment_config: FragmentConfig = preload(
	"res://scenes/objects/pots/pot_fragment_config/pot_fragment_config.tres"
)
@onready var _dust_puff_resource := preload("res://scenes/objects/pots/dust_puff/dust_puff.tscn")


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], direction: Vector2) -> void:
	_spawn_fragments(direction)
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.POT_BREAK)
	_spawn_dust_puff()

	queue_free()


func _spawn_fragments(direction: Vector2) -> void:
	var fragment_spawner: FragmentSpawner = _fragment_spawner_resource.instantiate()
	fragment_spawner.global_position = global_position
	fragment_spawner.fragment_config = _fragment_config
	LevelManager.current_level.add_child(fragment_spawner)

	fragment_spawner.spawn_fragments(direction)


func _spawn_dust_puff() -> void:
	var dust_puff: Sprite2D = _dust_puff_resource.instantiate()
	dust_puff.global_position = global_position
	LevelManager.current_level.add_child(dust_puff)
