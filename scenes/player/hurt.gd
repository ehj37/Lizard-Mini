extends PlayerState

const HURT_MOVE_SPEED := 30.0


func update(_delta: float) -> void:
	var movement_dir = player.get_movement_direction()

	if movement_dir != Vector2.ZERO:
		player.sprite.flip_h = movement_dir.x < 0
		player.velocity = movement_dir * HURT_MOVE_SPEED
		player.orientation = movement_dir
	else:
		player.velocity = Vector2.ZERO

	if animation_player.is_playing():
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if movement_dir != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(_data := {}):
	player.velocity = Vector2.ZERO

	var animation = _get_animation(player.orientation)
	animation_player.play(animation)

	if player.orientation.x < 0:
		player.sprite.flip_h = true

	player.hurtbox.disable()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	player.hurtbox.enable()


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
			animation = "hurt_up"
		Vector2.RIGHT:
			animation = "hurt_side"
		Vector2.DOWN:
			animation = "hurt_down"
		Vector2.LEFT:
			animation = "hurt_side"

	assert(animation != "", "Could not match direction to run animation.")
	return animation
