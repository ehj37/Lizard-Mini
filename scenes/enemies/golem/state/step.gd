extends GolemState

const STEP_DURATION: float = 0.5
const MAX_SPEED: float = 50.0
const MOVE_ACCELERATION: float = 250.0
const MOVE_DECELERATION: float = 170.0

var _safe_velocity: Vector2


func update(delta: float) -> void:
	golem.velocity = golem.velocity.move_toward(Vector2.ZERO, MOVE_DECELERATION * delta)


func enter(_data: Dictionary = {}) -> void:
	golem.color_rect.color = Color.AQUAMARINE
	golem.velocity = _safe_velocity.normalized() * MAX_SPEED

	get_tree().create_timer(STEP_DURATION).timeout.connect(_on_step_timer_timeout)


func _on_step_timer_timeout() -> void:
	if can_attack():
		transition_to("PreAttack")
	else:
		transition_to("Step")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	_safe_velocity = safe_velocity
