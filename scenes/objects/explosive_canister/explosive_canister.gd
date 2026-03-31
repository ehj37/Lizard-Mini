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


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	hurtbox.disable()
	hurtbox_ground.disable()

	SoundEffectManager.cancel(_ambience_sound_effect_identifier)

	var explosion: Node2D = explosion_resource.instantiate()
	explosion.global_position = global_position
	LevelManager.current_level.add_child(explosion)

	SignalBus.shake_camera.emit()

	queue_free()
