extends WipEnemyState

const ALERT_DURATION: float = 0.3


func enter(_data: Dictionary = {}) -> void:
	(state_machine as WipEnemyStateMachine).set_player()
	wip_enemy.color_rect.color = Color.RED
	get_tree().create_timer(ALERT_DURATION).timeout.connect(_on_alert_timer_timeout)


func _on_alert_timer_timeout() -> void:
	# Or I have something on the state machine to make a decision?
	# state_machine.pick_next_state or .pick_next_state_based_on_player
	# Instead—transition to decide. Can attack straight out of alert.
	state_machine.transition_to("Move")
