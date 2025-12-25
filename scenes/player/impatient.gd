extends PlayerState


func update(_delta: float) -> void:
	var movement_direction = player.get_movement_direction()

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if movement_direction != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	if !animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data := {}):
	player.orientation = Vector2(player.orientation.x, 0).normalized()
	player.velocity = Vector2.ZERO
	animation_player.play("impatient_side")

	player.sprite.flip_h = player.orientation.x < 0


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()
