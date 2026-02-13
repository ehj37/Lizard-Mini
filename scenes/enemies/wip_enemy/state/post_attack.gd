extends WipEnemyState

const BASE_PAUSE_DURATION = 0.6
const PAUSE_DURATION_VARIANCE = 0.2


func enter(_data := {}) -> void:
	wip_enemy.velocity = Vector2.ZERO
	var pause_duration := randf_range(
		BASE_PAUSE_DURATION - PAUSE_DURATION_VARIANCE, BASE_PAUSE_DURATION + PAUSE_DURATION_VARIANCE
	)
	get_tree().create_timer(pause_duration).timeout.connect(_on_pause_timer_timeout)


func _on_pause_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	state_machine.transition_to("Step")
