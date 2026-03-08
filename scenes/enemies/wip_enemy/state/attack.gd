extends WipEnemyState

const PAUSE_DURATION: float = 0.8
const LUNGE_DURATION: float = 0.1
const ATTACK_DURATION: float = 0.1
const POST_ATTACK_DURATION: float = 0.7
const LUNGE_INITIAL_SPEED: float = 400.0

var _is_combo: bool = 0

# TODO: Attack chaining
# If attacking multiple times, make the attack radius larger on combo attacks?
# TODO: Ensure that this can damage other enemies
# TODO: Consider if I want something different for a combo attack than the normal attack.


func enter(data: Dictionary = {}) -> void:
	_is_combo = data.get("is_combo", false)
	wip_enemy.color_rect.color = Color.ORANGE
	wip_enemy.velocity = Vector2.ZERO
	get_tree().create_timer(PAUSE_DURATION).timeout.connect(_commit_to_action)


func exit() -> void:
	wip_enemy.attack_cooldown_timer.start()


func _commit_to_action() -> void:
	# TODO
	# Whenever I find myself doing this, it's probably a sign I should add more states.
	if state_machine.current_state != self:
		return

	wip_enemy.color_rect.color = Color.RED

	if _is_combo:
		_attack()
	else:
		_lunge()


func _lunge() -> void:
	if state_machine.current_state != self:
		return

	var to_player: Vector2 = wip_enemy.global_position.direction_to(player.global_position)
	wip_enemy.velocity = to_player * LUNGE_INITIAL_SPEED
	var lunge_tween: Tween = get_tree().create_tween()
	lunge_tween.tween_property(wip_enemy, "velocity", Vector2.ZERO, LUNGE_DURATION)
	lunge_tween.set_ease(Tween.EASE_OUT)
	lunge_tween.finished.connect(_attack)


func _attack() -> void:
	if state_machine.current_state != self:
		return

	wip_enemy.hitbox.enable()
	wip_enemy.damage_visual.show()
	get_tree().create_timer(ATTACK_DURATION).timeout.connect(_post_attack)


func _post_attack() -> void:
	if state_machine.current_state != self:
		return

	wip_enemy.hitbox.disable()
	wip_enemy.damage_visual.hide()
	wip_enemy.color_rect.color = Color.BLUE

	get_tree().create_timer(POST_ATTACK_DURATION).timeout.connect(_on_post_attack_timer_timeout)


func _on_post_attack_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var distance_to_player: float = wip_enemy.global_position.distance_to(player.global_position)
	if distance_to_player < ATTACK_RANGE && !_is_combo:
		state_machine.transition_to("Attack", {"is_combo": true})
	else:
		state_machine.transition_to("Step")
