extends GolemState

const LUNGE_DURATION: float = 0.1
const LUNGE_INITIAL_SPEED: float = 400.0

var _lunge_tween: Tween


func enter(_data: Dictionary = {}) -> void:
	var to_player: Vector2 = golem.global_position.direction_to(player.global_position)
	golem.velocity = to_player * LUNGE_INITIAL_SPEED
	_lunge_tween = get_tree().create_tween()
	_lunge_tween.tween_property(golem, "velocity", Vector2.ZERO, LUNGE_DURATION)
	_lunge_tween.set_ease(Tween.EASE_OUT)
	await _lunge_tween.finished

	transition_to("Slam")


func exit() -> void:
	if _lunge_tween.is_valid:
		_lunge_tween.cancel_free()
