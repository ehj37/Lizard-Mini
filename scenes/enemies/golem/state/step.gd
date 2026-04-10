extends GolemState

const MAX_SPEED: float = 50.0
const MOVE_ACCELERATION: float = 250.0
const MOVE_DECELERATION: float = 170.0

var _safe_velocity: Vector2


func update(delta: float) -> void:
	golem.velocity = golem.velocity.move_toward(Vector2.ZERO, MOVE_DECELERATION * delta)
	if !golem.animation_player.is_playing():
		if can_attack():
			transition_to("DecideAttack")
		else:
			transition_to("Step")


func enter(_data: Dictionary = {}) -> void:
	golem.velocity = _safe_velocity.normalized() * MAX_SPEED
	golem.sprite.flip_h = golem.velocity.x < 0
	golem.animation_player.play("step")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	_safe_velocity = safe_velocity
