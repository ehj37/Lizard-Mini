extends PlayerState

@onready var impatient_timer: Timer = $ImpatientTimer


func update(_delta: float) -> void:
	var movement_direction = player.get_movement_direction()

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if movement_direction != Vector2.ZERO:
		state_machine.transition_to("Run")


func enter(_data := {}):
	player.velocity = Vector2.ZERO

	var animation = _get_animation(player.orientation)
	animation_player.play(animation)

	player.sprite.flip_h = player.orientation.x < 0

	impatient_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	impatient_timer.stop()


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

	match closest_cardinal_dir:
		Vector2.UP:
			return "idle_up"
		Vector2.RIGHT:
			return "idle_side"
		Vector2.DOWN:
			return "idle_down"
		_:
			return "idle_side"


func _on_impatient_timer_timeout():
	state_machine.transition_to("Impatient")
