extends StaticBody2D

var _ambience_identifier: int

@onready var explosion_resource := preload("./explosion/explosive_canister_explosion.tscn")
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround


func _ready() -> void:
	_ambience_identifier = AudioManager.play_effect_at(
		global_position, SoundEffectConfiguration.Type.CANISTER_AMBIENCE
	)


func take_damage(_amount: int, _type: Hitbox.DamageType, _direction: Vector2) -> void:
	hurtbox.disable()
	hurtbox_ground.disable()

	AudioManager.cancel_audio(SoundEffectConfiguration.Type.CANISTER_AMBIENCE, _ambience_identifier)

	var explosion: Node2D = explosion_resource.instantiate()
	explosion.global_position = global_position
	LevelManager.current_level.add_child(explosion)

	EventBus.explosion.emit()

	queue_free()
