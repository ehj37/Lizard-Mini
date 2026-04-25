extends PlayerState


func handle_input(event: InputEvent) -> void:
	if player._in_cinematic:
		return

	if event.is_action_pressed("attack"):
		if player.attack_cooldown_timer.is_stopped():
			state_machine.transition_to("Attack")
			return

	if event.is_action_pressed("dash"):
		if player.dash_cooldown_timer.is_stopped():
			state_machine.transition_to("Dash")
			return

	if event.is_action_pressed("interact"):
		var interact_area: InteractArea = InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
			return

	var movement_direction: Vector2 = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		state_machine.transition_to("Run")


func update(_delta: float) -> void:
	if !animation_player.is_playing():
		state_machine.transition_to("Idle", {"impatient": true})


func enter(_data: Dictionary = {}) -> void:
	player.orientation = Vector2(player.orientation.x, 0).normalized()
	player.velocity = Vector2.ZERO
	animation_player.play("impatient_right")

	player.sprite.flip_h = player.orientation.x < 0


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()
