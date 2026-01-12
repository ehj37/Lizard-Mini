extends PlayerState

const INITIAL_SPEED := 120.0
const DECELERATION := 350.0

var _current_velocity: Vector2


func update(delta: float) -> void:
	_current_velocity = _current_velocity.move_toward(Vector2.ZERO, delta * DECELERATION)
	player.velocity = _current_velocity

	if !player.animation_player.is_playing():
		state_machine.transition_to("Rise")


func enter(data := {}) -> void:
	player.sprite_shadow.visible = false
	var damage_direction = data.get("damage_direction") as Vector2
	# Set orientation to left or right because the player transitions to idle
	# right/idle left out of the Rise state.
	if damage_direction.x < 0:
		player.sprite.flip_h = true
		player.orientation = Vector2.LEFT
	else:
		player.sprite.flip_h = false
		player.orientation = Vector2.RIGHT

	_current_velocity = damage_direction * INITIAL_SPEED
	player.velocity = _current_velocity

	player.animation_player.play("fall_right")


func _play_thud_sound() -> void:
	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_FALL_THUD
	)
