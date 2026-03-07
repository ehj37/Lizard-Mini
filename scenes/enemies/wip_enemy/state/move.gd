extends WipEnemyState

const MAX_SPEED: float = 20.0
const MOVE_ACCELERATION: float = 250.0


func update(delta: float) -> void:
	# No navigation agent towards? Something different?
	var to_player: Vector2 = wip_enemy.global_position.direction_to(player.global_position)
	wip_enemy.velocity = wip_enemy.velocity.move_toward(
		to_player * MAX_SPEED, MOVE_ACCELERATION * delta
	)


func enter(_data: Dictionary = {}) -> void:
	wip_enemy.color_rect.color = Color.AQUAMARINE
