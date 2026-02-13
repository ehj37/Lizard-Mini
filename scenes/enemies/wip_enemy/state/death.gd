extends WipEnemyState


func enter(_data := {}) -> void:
	wip_enemy.velocity = Vector2.ZERO
	wip_enemy.collision_shape.disabled = true
	wip_enemy.hurtbox.disable()
	wip_enemy.hurtbox_ground.disable()
	wip_enemy.hitbox_ground.disable()
	wip_enemy.animation_player.play("death")
