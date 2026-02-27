extends WipEnemyState


func update(_delta: float) -> void:
	if !on_ground():
		state_machine.transition_to("Fall")
		return

	if Input.is_action_just_pressed("break"):
		# TODO: Change set_player to take player as a param if I have it here?
		# (for when I actually do proper detection)
		@warning_ignore("unsafe_method_access")
		state_machine.set_player()

		state_machine.transition_to("Alerted")


func enter(_data: Dictionary = {}) -> void:
	wip_enemy.animation_player.play("idle")
	var idle_animation_length: float = wip_enemy.animation_player.get_animation("idle").length
	wip_enemy.animation_player.advance(randf_range(0.0, idle_animation_length))
