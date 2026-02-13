extends WipEnemyState

const ATTACK_LUNGE_SPEED = 300.0
const ATTACK_LUNGE_DURATION = 0.2
const DECELERATION_START = 0.1

var _direction: Vector2
var _deceleration_tween: Tween


func update(_delta: float) -> void:
	wip_enemy.velocity = _direction * ATTACK_LUNGE_SPEED


func enter(data := {}) -> void:
	wip_enemy.collision_shape.set_deferred("disabled", true)
	wip_enemy.hitbox_ground.enable()

	get_tree().create_timer(DECELERATION_START).timeout.connect(
		_on_deceleration_start_timer_timeout
	)

	var target: Vector2 = data.get("target")
	_direction = wip_enemy.global_position.direction_to(target)
	get_tree().create_timer(ATTACK_LUNGE_DURATION).timeout.connect(_on_lunge_timer_timeout)


func exit() -> void:
	wip_enemy.collision_shape.set_deferred("disabled", false)
	wip_enemy.hitbox_ground.disable()
	if is_instance_valid(_deceleration_tween):
		_deceleration_tween.stop()


func _on_deceleration_start_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var deceleration_time := ATTACK_LUNGE_DURATION - DECELERATION_START
	_deceleration_tween = get_tree().create_tween()
	_deceleration_tween.tween_property(wip_enemy, "velocity", Vector2.ZERO, deceleration_time)


func _on_lunge_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	state_machine.transition_to("PostAttack")  # ?
