extends GolemState

const POST_ATTACK_DURATION: float = 1.2
const COMBO_ATTACK_RANGE: float = 60.0


func enter(data: Dictionary = {}) -> void:
	golem.hitbox.disable()
	golem.damage_visual.hide()
	golem.color_rect.color = Color.BLUE

	await get_tree().create_timer(POST_ATTACK_DURATION, false).timeout

	var can_combo: bool = data.get("can_combo")
	if can_combo:
		var distance_to_player: float = golem.global_position.distance_to(player.global_position)
		if distance_to_player < COMBO_ATTACK_RANGE:
			transition_to("Slam", {"is_combo": true})
			return

	transition_to("Step")
