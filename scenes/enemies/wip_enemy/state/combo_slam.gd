extends WipEnemyState


func enter(_data: Dictionary = {}) -> void:
	PositionalAudioManager.play_audio_at(
		wip_enemy.global_position, PositionalAudioConfig.Type.WIP_ENEMY_SLAM
	)
	wip_enemy.hitbox.enable()
	wip_enemy.damage_visual.show()
	await get_tree().create_timer(HITBOX_ENABLE_DURATION).timeout

	transition_to("PostAttack", {"is_combo": true})
