extends PlayerState


func update(_delta: float) -> void:
	if player.animation_player.is_playing():
		return

	player.global_position = player.last_safe_global_position

	if player.ground_detector.current_status() == PlayerGroundDetector.Status.ON_SAFE_GROUND:
		state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	player.velocity = Vector2.ZERO
	player.clear_burn()

	# Setting state that'll be restored on exit
	player.hurtbox.disable()
	player.hurtbox_feet.disable()
	_toggle_collision(false)

	player.sprite_shadow.visible = false

	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_FALL_PIT
	)
	animation_player.play("fall_pit")


func exit() -> void:
	# Restoring state that was changed on enter
	player.hurtbox.enable()
	player.hurtbox_feet.enable()
	_toggle_collision(true)
	player.sprite_shadow.visible = true


# We do this instead of changing the disabled value for the player collision
# shape so the player is still detectable via a camera lock area (via the
# "CameraLockAreaDetectable" layer).
# If we disabled the collision shape on fall while in a camera lock zone,
# the camera lock would break, and potentially re-snap if the player spawned
# back into the same lock zone.
func _toggle_collision(on: bool) -> void:
	player.set_collision_layer_value(8, on)
