extends WipEnemyState


func enter(_data: Dictionary = {}) -> void:
	SoundEffectManager.play_at(wip_enemy.slam_sound_effect_config, wip_enemy.global_position)
	wip_enemy.hitbox.enable()
	wip_enemy.damage_visual.show()
	await get_tree().create_timer(HITBOX_ENABLE_DURATION).timeout

	transition_to("PostAttack")
