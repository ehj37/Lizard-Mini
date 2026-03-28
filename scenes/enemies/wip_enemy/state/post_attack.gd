extends WipEnemyState

const POST_ATTACK_DURATION: float = 1.2
const COMBO_ATTACK_RANGE: float = 60.0


func enter(data: Dictionary = {}) -> void:
	wip_enemy.hitbox.disable()
	wip_enemy.damage_visual.hide()
	wip_enemy.color_rect.color = Color.BLUE

	await get_tree().create_timer(POST_ATTACK_DURATION).timeout

	var can_combo: bool = !data.get("is_combo", false)
	if can_combo:
		var distance_to_player: float = wip_enemy.global_position.distance_to(
			player.global_position
		)
		if distance_to_player < COMBO_ATTACK_RANGE:
			transition_to("ComboSlam")
			return

	transition_to("Step")
