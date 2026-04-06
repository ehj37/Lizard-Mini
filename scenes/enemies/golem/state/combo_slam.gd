extends GolemState


func enter(_data: Dictionary = {}) -> void:
	SoundEffectManager.play_at(golem.slam_sound_effect_config, golem.global_position)
	golem.hitbox.enable()
	golem.damage_visual.show()
	await get_tree().create_timer(HITBOX_ENABLE_DURATION).timeout

	transition_to("PostAttack", {"is_combo": true})
