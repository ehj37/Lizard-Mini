extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	PositionalAudioManager.play_audio_at(
		global_position, PositionalAudioConfig.Type.CANISTER_EXPLOSION
	)

	animation_player.play("boom")
	await animation_player.animation_finished

	queue_free()
