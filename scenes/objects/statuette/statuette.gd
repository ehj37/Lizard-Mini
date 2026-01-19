extends StaticBody2D

@onready var dust_puff_resource := preload(
	"res://scenes/objects/statuette/statuette_dust_puff/statuette_dust_puff.tscn"
)
@onready var sprite_statuette: Sprite2D = $SpriteStatuette
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var fragment_spawner: FragmentSpawner = $FragmentSpawner


func take_damage(_amount: int, _type: Hitbox.DamageType, direction: Vector2) -> void:
	sprite_statuette.visible = false
	fragment_spawner.spawn_fragments(direction)
	var dust_puff = dust_puff_resource.instantiate() as Sprite2D
	dust_puff.global_position = global_position
	owner.add_child(dust_puff)
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.STATUETTE_BREAK)
	collision_shape.disabled = true

	hurtbox.disable()
