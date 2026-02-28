extends CorvidState

const ATTACK_LUNGE_SPEED: float = 375.0
const ATTACK_LUNGE_DURATION: float = 0.2
const HITBOX_ENABLE_TIME: float = 0.1
const DECELERATION_START: float = 0.1

var _direction: Vector2
var _deceleration_tween: Tween


func physics_update(_delta: float) -> void:
	corvid.velocity = _direction * ATTACK_LUNGE_SPEED


# Hitbox gets enabled via animation
func enter(data: Dictionary = {}) -> void:
	corvid.animation_player.play("attack")

	corvid.set_collision_mask_value(8, false)

	get_tree().create_timer(DECELERATION_START).timeout.connect(
		_on_deceleration_start_timer_timeout
	)

	var target: Vector2 = data.get("target")
	_direction = corvid.global_position.direction_to(target)
	if _direction.x < 0:
		corvid.hitbox.position.x = -abs(corvid.hitbox.position.x)
	else:
		corvid.hitbox.position.x = abs(corvid.hitbox.position.x)

	get_tree().create_timer(ATTACK_LUNGE_DURATION).timeout.connect(_on_lunge_timer_timeout)


func exit() -> void:
	corvid.set_collision_mask_value(8, true)
	corvid.hitbox.disable()

	if is_instance_valid(_deceleration_tween):
		_deceleration_tween.stop()


func _on_deceleration_start_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var deceleration_time: float = ATTACK_LUNGE_DURATION - DECELERATION_START
	_deceleration_tween = get_tree().create_tween()
	_deceleration_tween.tween_property(corvid, "velocity", Vector2.ZERO, deceleration_time)


func _on_lunge_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	state_machine.transition_to("PostAttack")
