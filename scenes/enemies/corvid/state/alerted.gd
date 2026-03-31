extends CorvidState

@onready var _alert_sound_effect_config: SoundEffectConfig = load(
	"res://scenes/enemies/corvid/sound_effects/corvid_alert.tres"
)


func update(_delta: float) -> void:
	if !corvid.animation_player.is_playing():
		state_machine.transition_to("Decide")


func enter(_data: Dictionary = {}) -> void:
	corvid.animation_player.play("alerted")
	SoundEffectManager.play_at(_alert_sound_effect_config, corvid.global_position)


func _set_alerted() -> void:
	corvid.alerted = true
