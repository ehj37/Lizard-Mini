extends WipEnemyState

const ATTACK_RANGE = 40


func enter(_data := {}) -> void:
	var player_in_range := (
		wip_enemy.global_position.distance_to(player.global_position) < ATTACK_RANGE
	)
	if player_in_range && player.in_reachable_state():
		state_machine.transition_to("PreAttack")
		return

	state_machine.transition_to("Step")
