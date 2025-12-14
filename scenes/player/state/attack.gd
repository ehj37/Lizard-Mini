extends PlayerState

enum SwingDirection {}

const INITIAL_LUNGE_SPEED := 80.0
const LUNGE_DECELERATION := 350.0
const HITBOX_ENABLED_DELAY := 0.075
const HITBOX_ENABLED_DURATION := 0.075

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
	_speed = max(_speed - LUNGE_DECELERATION * delta, 0.0)
	player.velocity = player.orientation * _speed


func update(_delta: float) -> void:
	if animation_player.is_playing():
		return

	if player.get_movement_direction() != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	player.hitbox_sword.disabled = false

	var movement_direction = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		_lunge_dir = movement_direction
	else:
		_lunge_dir = player.orientation

	var animation = _get_animation(_lunge_dir)
	animation_player.play(animation)

	if _lunge_dir.x < 0:
		player.sprite.flip_h = true
		player.hitbox_sword.scale.x = -1
	else:
		player.sprite.flip_h = false
		player.hitbox_sword.scale.x = 1

	_speed = INITIAL_LUNGE_SPEED
	player.velocity = _lunge_dir * INITIAL_LUNGE_SPEED
	player.hitbox_sword.damage_direction = player.orientation


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	player.disable_sword()


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
			animation = "swing_up_right_1"
		Vector2.RIGHT:
			animation = "swing_right_1"
		DIR_DR:
			animation = "swing_down_right_1"
		Vector2.DOWN:
			animation = "swing_down_1"
		DIR_DL:
			animation = "swing_down_right_1"
		Vector2.LEFT:
			animation = "swing_right_1"
		DIR_UL:
			animation = "swing_up_right_1"

	assert(animation != "", "Unhandled direction, could not find attack animation.")
	return animation
