extends WipEnemyState

const LOCK_TARGET_TIME = 0.5
const PRE_ATTACK_DURATION = 0.8

var _target: Vector2


func enter(_data := {}) -> void:
	get_tree().create_timer(LOCK_TARGET_TIME).timeout.connect(_on_lock_target_timer_timeout)
	get_tree().create_timer(PRE_ATTACK_DURATION).timeout.connect(_on_pre_attack_timer_timeout)


func update(_delta: float) -> void:
	if !on_ground():
		state_machine.transition_to("Fall")


func _on_lock_target_timer_timeout() -> void:
	if player.in_reachable_state():
		_target = player.global_position
	else:
		state_machine.transition_to("Bide")


func _on_pre_attack_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	# TODO: Or attack 2, or dash away maybe? Or back to step if the player is
	# out of range?
	state_machine.transition_to("Attack1", {"target": _target})
