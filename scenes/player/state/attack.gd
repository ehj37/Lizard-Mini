extends PlayerState

enum SwingDirection {}

const INITIAL_LUNGE_SPEED := 80.0
const LUNGE_DECELERATION := 350.0
const COMBO_WINDOW_START := 0.225
const MAX_COMBO_NUM := 2
const DIR_UR := Vector2(1, -1)
const DIR_DR := Vector2(1, 1)
const DIR_DL := Vector2(-1, 1)
const DIR_UL := Vector2(-1, -1)
const ATTACK_DIRECTIONS: Array[Vector2] = [
	Vector2.UP, DIR_UR, Vector2.RIGHT, DIR_DR, Vector2.DOWN, DIR_DL, Vector2.LEFT, DIR_UL
]

var _lunge_dir: Vector2
var _speed := 0.0
var _can_combo := false
var _combo_num: int


func physics_update(delta: float) -> void:
	_speed = max(_speed - LUNGE_DECELERATION * delta, 0.0)
	player.velocity = player.orientation * _speed


func update(_delta: float) -> void:
	if _can_combo:
		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack", {"combo_num": _combo_num + 1})

	if animation_player.is_playing():
		return

	if player.get_movement_direction() != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(data := {}) -> void:
	player.hitbox_sword.disabled = false

	var movement_direction = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		_lunge_dir = movement_direction
		player.orientation = movement_direction
	else:
		_lunge_dir = player.orientation

	_combo_num = data.get("combo_num", 0)
	var animation = _get_animation(_lunge_dir, _combo_num)
	animation_player.play(animation)
	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_SWORD_SWING
	)

	if _lunge_dir.x < 0:
		player.sprite.flip_h = true
		player.hitbox_sword.scale.x = -1
	else:
		player.sprite.flip_h = false
		player.hitbox_sword.scale.x = 1

	_speed = INITIAL_LUNGE_SPEED
	player.velocity = _lunge_dir * INITIAL_LUNGE_SPEED
	player.hitbox_sword.damage_direction = player.orientation

	_can_combo = false
	get_tree().create_timer(COMBO_WINDOW_START).timeout.connect(_enter_combo_window)


func exit() -> void:
	if animation_player.is_playing():
		AudioManager.cancel_audio(SoundEffectConfiguration.Type.PLAYER_SWORD_SWING)
		animation_player.stop()

	player.disable_sword()
	# This is fine for combo attacks since they don't check the timer.
	player.attack_cooldown_timer.start()


func _get_animation(dir: Vector2, combo_num: int) -> String:
	var smallest_angle = INF
	var closest_dir: Vector2
	# Order matters here for diagonal tiebreaking.
	# Favoring horizontal run animations over vertical.
	for candidate_dir in ATTACK_DIRECTIONS:
		var wrapped_angle = wrapf(dir.angle_to(candidate_dir), 0.0, TAU)
		var angle_diff_magnitude = min(wrapped_angle, TAU - wrapped_angle)
		# Some tolerance here for the diagonal behavior described above.
		if angle_diff_magnitude + .01 < smallest_angle:
			smallest_angle = angle_diff_magnitude
			closest_dir = candidate_dir

	var animation = ""
	match closest_dir:
		Vector2.UP:
			match combo_num:
				0:
					animation = "swing_up_1"
				1:
					animation = "swing_up_1"  # TODO
				2:
					animation = "swing_up_1"  # TODO
		DIR_UR, DIR_UL:
			match combo_num:
				0:
					animation = "swing_up_right_1"
				1:
					animation = "swing_up_right_1"  # TODO
				2:
					animation = "swing_up_right_1"  # TODO
		Vector2.RIGHT, Vector2.LEFT:
			match combo_num:
				0:
					animation = "swing_right_1"
				1:
					animation = "swing_right_2"
				2:
					animation = "swing_right_1"  # TODO
		DIR_DR, DIR_DL:
			match combo_num:
				0:
					animation = "swing_down_right_1"
				1:
					animation = "swing_down_right_1"  # TODO
				2:
					animation = "swing_down_right_1"  # TODO
		Vector2.DOWN:
			match combo_num:
				0:
					animation = "swing_down_1"
				1:
					animation = "swing_down_1"  # TODO
				2:
					animation = "swing_down_1"  # TODO

	assert(animation != "", "Unhandled direction, could not find attack animation.")
	return animation


func _enter_combo_window() -> void:
	if state_machine.current_state != self:
		return

	if _combo_num < MAX_COMBO_NUM:
		_can_combo = true
