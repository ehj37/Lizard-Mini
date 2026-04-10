extends GolemState


func enter(_data: Dictionary = {}) -> void:
	golem.animation_player.play("death")

	golem.collision_shape.disabled = true
	golem.hurtbox.disable()
	golem.navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
	golem.velocity = Vector2.ZERO
	golem.z_index = -3


func exit() -> void:
	assert(false, "This shouldn't happen. The dead should remain dead.")
