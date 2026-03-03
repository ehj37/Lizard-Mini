extends StaticBody2D

var _ambience_identifier: int

@onready
var explosion_resource: PackedScene = preload("./explosion/explosive_canister_explosion.tscn")
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround


func _ready() -> void:
	_ambience_identifier = PositionalAudioManager.play_audio_at(
		global_position, PositionalAudioConfig.Type.CANISTER_AMBIENCE
	)


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	hurtbox.disable()
	hurtbox_ground.disable()

	PositionalAudioManager.cancel_audio(
		PositionalAudioConfig.Type.CANISTER_AMBIENCE, _ambience_identifier
	)

	var explosion: Node2D = explosion_resource.instantiate()
	explosion.global_position = global_position
	LevelManager.current_level.add_child(explosion)

	SignalBus.shake_camera.emit()

	queue_free()
