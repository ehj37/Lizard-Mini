extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SoundEffectManager.play_effect_at(global_position, SoundEffectConfig.Type.CANISTER_EXPLOSION)

	animation_player.play("boom")
	await animation_player.animation_finished

	queue_free()
