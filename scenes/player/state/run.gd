extends PlayerState

const MOVE_SPEED := 80.0


func update(_delta: float) -> void:
	var movement_dir = player.get_movement_direction()

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if movement_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	var animation = _get_animation(movement_dir)
	if animation_player.current_animation != animation:
		animation_player.current_animation = animation

	player.sprite.flip_h = movement_dir.x < 0
	player.velocity = movement_dir * MOVE_SPEED
	player.orientation = movement_dir


func enter(_data := {}) -> void:
	var animation = _get_animation(player.orientation)
	animation_player.play(animation)


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()


func _get_animation(dir: Vector2) -> String:
	var smallest_angle = INF
	var closest_cardinal_dir: Vector2
	# Order matters here for diagonal tiebreaking.
	# Favoring horizontal run animations over vertical.
	for cardinal_dir in [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]:
		var wrapped_angle = wrapf(dir.angle_to(cardinal_dir), 0.0, TAU)
		var angle_diff_magnitude = min(wrapped_angle, TAU - wrapped_angle)
		# Some tolerance here for the diagonal behavior described above.
		if angle_diff_magnitude + .01 < smallest_angle:
			smallest_angle = angle_diff_magnitude
			closest_cardinal_dir = cardinal_dir

	var animation: String = ""
	match closest_cardinal_dir:
		Vector2.UP:
			animation = "run_up"
		Vector2.RIGHT:
			animation = "run_side"
		Vector2.DOWN:
			animation = "run_down"
		Vector2.LEFT:
			animation = "run_side"

	assert(animation != "", "Could not match direction to run animation.")
	return animation
