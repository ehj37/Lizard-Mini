extends PlayerState

const INITIAL_LUNGE_SPEED := 50.0
const LUNGE_DECELERATION := 200.0

const DIR_UR := Vector2(1, -1)
const DIR_DR := Vector2(1, 1)
const DIR_DL := Vector2(-1, 1)
const DIR_UL := Vector2(-1, -1)
const ATTACK_DIRECTIONS: Array[Vector2] = [
	Vector2.UP, DIR_UR, Vector2.RIGHT, DIR_DR, Vector2.DOWN, DIR_DL, Vector2.LEFT, DIR_UL
]

var _lunge_dir: Vector2
var _speed := 0.0


func physics_update(delta: float) -> void:
	_speed = _speed - LUNGE_DECELERATION * delta
	player.velocity = player.orientation * _speed


func update(_delta: float) -> void:
	if animation_player.is_playing():
		return

	if player.get_movement_direction() != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	var movement_direction = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		_lunge_dir = movement_direction
	else:
		_lunge_dir = player.orientation

	var animation = _get_animation(_lunge_dir)
	animation_player.play(animation)

	if _lunge_dir.x < 0:
		player.sprite.flip_h = true

	_speed = INITIAL_LUNGE_SPEED
	player.velocity = _lunge_dir * INITIAL_LUNGE_SPEED


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()


func _get_animation(dir: Vector2) -> String:
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
			animation = "swing_up_1"
		DIR_UR:
			animation = "swing_right_1"  # TODO
		Vector2.RIGHT:
			animation = "swing_right_1"
		DIR_DR:
			animation = "swing_right_1"  # TODO
		Vector2.DOWN:
			animation = "swing_down_1"
		DIR_DL:
			animation = "swing_right_1"  # TODO
		Vector2.LEFT:
			animation = "swing_right_1"
		DIR_UL:
			animation = "swing_right_1"  # TODO

	assert(animation != "", "Unhandled direction, could not find attack animation.")
	return animation
