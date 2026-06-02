extends StaticBody2D

var _ambience_sound_effect_identifier: int

@onready
var explosion_resource: PackedScene = preload("./explosion/explosive_canister_explosion.tscn")
@onready var ambience_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/objects/explosive_canister/sound_effects/canister_ambience.tres"
)
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround


func _ready() -> void:
	_ambience_sound_effect_identifier = SoundEffectManager.play_at(
		ambience_sound_effect_config, global_position
	)


func _on_hurtbox_hitbox_connected(
	_damage_direction: Vector2, _damage_types: Array[Hitbox.DamageType]
) -> void:
	hurtbox.disable()
	hurtbox_ground.disable()

	SoundEffectManager.cancel(_ambience_sound_effect_identifier)

	var explosion: Node2D = explosion_resource.instantiate()
	explosion.global_position = global_position
	LevelManager.current_level.add_child(explosion)

	SignalBus.shake_camera.emit(SignalBus.CameraShakeMagnitude.LARGE, Vector2.ZERO)

	queue_free()
