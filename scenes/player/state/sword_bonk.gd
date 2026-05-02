extends PlayerState

const _ANIMATION_MAP: Dictionary = {
	0.0: "sword_bonk_right",
	PI / 2: "sword_bonk_down",
	PI: "sword_bonk_right",
	3 * PI / 2: "sword_bonk_up",
}

@onready var _sword_bonk_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_sword_bonk.tres"
)


func update(_delta: float) -> void:
	if !animation_player.is_playing():
		transition_to("Idle")


func enter(data: Dictionary = {}) -> void:
	player.velocity = Vector2.ZERO
	var lunge_dir: Vector2 = data.get("lunge_dir")
	var animation_name: String = AnimationPicker.pick_animation(_ANIMATION_MAP, lunge_dir.angle())

	animation_player.play(animation_name)
	SoundEffectManager.play(_sword_bonk_sound_effect_config)
