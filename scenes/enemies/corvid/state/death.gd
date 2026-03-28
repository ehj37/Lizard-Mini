extends CorvidState


func update(_delta: float) -> void:
	if !corvid.animation_player.is_playing():
		corvid.z_index = -3
		corvid.process_mode = Node.PROCESS_MODE_DISABLED


func enter(_data: Dictionary = {}) -> void:
	PositionalAudioManager.play_audio_at(
		corvid.global_position, PositionalAudioConfig.Type.CORVID_DEATH
	)
	corvid.sprite_shadow.visible = false
	corvid.velocity = Vector2.ZERO
	corvid.collision_shape.disabled = true
	corvid.hurtbox.disable()
	corvid.hurtbox_ground.disable()
	corvid.hitbox.disable()
	corvid.animation_player.play("death")
