extends WipEnemyState

const ALERT_DURATION: float = 0.3


func enter(_data: Dictionary = {}) -> void:
	(state_machine as WipEnemyStateMachine).set_player()
	wip_enemy.color_rect.color = Color.RED
	get_tree().create_timer(ALERT_DURATION).timeout.connect(_on_alert_timer_timeout)


func _on_alert_timer_timeout() -> void:
	wip_enemy.alerted = true

	if can_attack():
		transition_to("PreAttack")
	else:
		transition_to("Step")
