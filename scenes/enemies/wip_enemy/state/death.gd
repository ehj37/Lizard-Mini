extends WipEnemyState


func enter(_data: Dictionary = {}) -> void:
	# TODO: Replace with a dedicated sound
	SoundEffectManager.play_effect_at(wip_enemy.global_position, SoundEffectConfig.Type.PLAYER_OUCH)
	wip_enemy.sprite_shadow.visible = false
	wip_enemy.velocity = Vector2.ZERO
	wip_enemy.collision_shape.disabled = true
	wip_enemy.hurtbox.disable()
	wip_enemy.hurtbox_ground.disable()
	wip_enemy.hitbox_ground.disable()
	wip_enemy.animation_player.play("death")
