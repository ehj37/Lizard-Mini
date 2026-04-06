extends GolemState


func enter(_data: Dictionary = {}) -> void:
	golem.color_rect.color = Color.SLATE_GRAY
	golem.hitbox.disable()
	golem.collision_shape.disabled = true
	golem.damage_visual.hide()
	golem.hurtbox.disable()
	golem.navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
	golem.velocity = Vector2.ZERO
	golem.z_index = -3
	golem.process_mode = Node.PROCESS_MODE_DISABLED


func exit() -> void:
	assert(false, "This shouldn't happen. The dead should remain dead.")
