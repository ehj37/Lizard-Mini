extends CorvidState

const ATTACK_RANGE: int = 40
const DECIDE_DURATION: float = 0.2


func enter(_data: Dictionary = {}) -> void:
	get_tree().create_timer(DECIDE_DURATION).timeout.connect(_on_decide_timer_timeout)


func _on_decide_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var player_in_range: bool = (
		corvid.global_position.distance_to(player.global_position) < ATTACK_RANGE
	)
	if player_in_range && player.in_reachable_state():
		state_machine.transition_to("PreAttack")
		return

	state_machine.transition_to("Step")
