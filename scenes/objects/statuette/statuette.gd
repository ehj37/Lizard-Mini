extends StaticBody2D

@onready var dust_puff_resource: PackedScene = preload(
	"res://scenes/objects/statuette/statuette_dust_puff/statuette_dust_puff.tscn"
)
@onready var sprite_statuette: Sprite2D = $SpriteStatuette
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround
@onready var fragment_spawner: FragmentSpawner = $FragmentSpawner
@onready var _break_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/objects/statuette/sound_effects/statuette_break.tres"
)


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], direction: Vector2) -> void:
	sprite_statuette.visible = false
	fragment_spawner.spawn_fragments(direction)
	var dust_puff: Sprite2D = dust_puff_resource.instantiate()
	dust_puff.global_position = global_position
	LevelManager.current_level.add_child(dust_puff)
	SoundEffectManager.play_at(_break_sound_effect_config, global_position)
	collision_shape.disabled = true

	hurtbox.disable()
	hurtbox_ground.disable()
