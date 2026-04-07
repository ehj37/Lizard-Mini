extends GolemState

const HITBOX_ENABLE_DURATION: float = 0.1


func enter(data: Dictionary = {}) -> void:
	var is_combo: bool = data.get("is_combo", false)

	SoundEffectManager.play_at(golem.slam_sound_effect_config, golem.global_position)
	golem.hitbox.enable()
	golem.damage_visual.show()
	await get_tree().create_timer(HITBOX_ENABLE_DURATION, false).timeout

	transition_to("PostSlam", {"can_combo": !is_combo})
