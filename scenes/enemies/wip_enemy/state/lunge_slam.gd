extends WipEnemyState

const LUNGE_DURATION: float = 0.1
const ATTACK_DURATION: float = 0.1
const POST_ATTACK_DURATION: float = 0.7
const LUNGE_INITIAL_SPEED: float = 400.0

var _lunge_tween: Tween


func enter(_data: Dictionary = {}) -> void:
	_lunge()


func exit() -> void:
	if _lunge_tween.is_valid:
		_lunge_tween.cancel_free()


func _lunge() -> void:
	var to_player: Vector2 = wip_enemy.global_position.direction_to(player.global_position)
	wip_enemy.velocity = to_player * LUNGE_INITIAL_SPEED
	_lunge_tween = get_tree().create_tween()
	_lunge_tween.tween_property(wip_enemy, "velocity", Vector2.ZERO, LUNGE_DURATION)
	_lunge_tween.set_ease(Tween.EASE_OUT)
	_lunge_tween.finished.connect(_slam)


func _slam() -> void:
	if !is_current_state():
		return

	SoundEffectManager.play_at(wip_enemy.slam_sound_effect_config, wip_enemy.global_position)

	wip_enemy.hitbox.enable()
	wip_enemy.damage_visual.show()
	await get_tree().create_timer(HITBOX_ENABLE_DURATION).timeout

	transition_to("PostAttack")
