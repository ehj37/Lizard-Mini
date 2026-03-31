extends Node2D

@onready var explosion_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/objects/explosive_canister/sound_effects/canister_explosion.tres"
)
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SoundEffectManager.play_at(explosion_sound_effect_config, global_position)

	animation_player.play("boom")
	await animation_player.animation_finished

	queue_free()
