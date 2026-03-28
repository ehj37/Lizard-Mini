extends WipEnemyState


func enter(_data: Dictionary = {}) -> void:
	wip_enemy.color_rect.color = Color.SLATE_GRAY
	wip_enemy.hitbox.disable()
	wip_enemy.collision_shape.disabled = true
	wip_enemy.damage_visual.hide()
	wip_enemy.hurtbox.disable()
	wip_enemy.navigation_agent.process_mode = Node.PROCESS_MODE_DISABLED
	wip_enemy.velocity = Vector2.ZERO
	wip_enemy.z_index = -3
	wip_enemy.process_mode = Node.PROCESS_MODE_DISABLED


func exit() -> void:
	assert(false, "This shouldn't happen. The dead should remain dead.")
