extends PlayerState


func update(_delta: float) -> void:
	if player.animation_player.is_playing():
		return

	player.global_position = player.last_safe_global_position

	if player.ground_detector.on_floor():
		state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	player.velocity = Vector2.ZERO

	# Setting state that'll be restored on exit
	player.hurtbox.disable()
	player.hurtbox_feet.disable()
	player.collision_shape.disabled = true
	player.sprite_shadow.visible = false

	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_FALL_PIT
	)
	animation_player.play("fall_pit")


func exit() -> void:
	# Restoring state that was changed on enter
	player.hurtbox.enable()
	player.hurtbox_feet.enable()
	player.collision_shape.disabled = false
	player.sprite_shadow.visible = true
