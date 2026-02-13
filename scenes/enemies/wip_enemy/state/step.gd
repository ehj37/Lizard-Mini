class_name WipEnemyStepState

extends WipEnemyState

const STEP_DURATION = 0.3
const STEP_SPEED = 125.0
const STEP_ANGLE_MAX_OFFSET_MAGNITUDE = PI / 8

var _safe_velocity: Vector2
var _speed: float

var _angle_sign := -1


func physics_update(_delta: float) -> void:
	wip_enemy.velocity = (
		_safe_velocity.normalized().rotated(_angle_sign * STEP_ANGLE_MAX_OFFSET_MAGNITUDE) * _speed
	)


func update(_delta: float) -> void:
	if !on_ground():
		state_machine.transition_to("Fall")


func enter(_data := {}) -> void:
	_speed = STEP_SPEED
	get_tree().create_tween().tween_property(self, "_speed", 0, STEP_DURATION)

	get_tree().create_timer(STEP_DURATION).timeout.connect(_on_step_timer_timeout)
	wip_enemy.animation_player.play("step")


func exit() -> void:
	_angle_sign *= -1


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	_safe_velocity = safe_velocity


func _on_step_timer_timeout() -> void:
	if state_machine.current_state == self:
		state_machine.transition_to("Decide")
