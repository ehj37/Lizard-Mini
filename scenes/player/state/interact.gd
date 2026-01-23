extends PlayerState

var _interact_area: InteractArea
var _interaction_complete := false


func update(delta: float) -> void:
	if !Input.is_action_pressed("interact") || _interaction_complete:
		var movement_direction := player.get_movement_direction()
		if movement_direction != Vector2.ZERO:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
		return

	_interact_area.interact(delta)


func enter(msg := {}) -> void:
	_interact_area = msg.get("interact_area")
	_interaction_complete = false
	_interact_area.interaction_complete.connect(func() -> void: _interaction_complete = true)
	player.velocity = Vector2.ZERO
	animation_player.play(_get_animation(player.orientation))


func exit() -> void:
	if !_interaction_complete:
		_interact_area.reset_progress()


func _get_animation(dir: Vector2) -> String:
	var smallest_angle := INF
	var closest_cardinal_dir: Vector2
	# Order matters here for diagonal tiebreaking.
	# Favoring horizontal interact animations over vertical.
	for cardinal_dir: Vector2 in [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]:
		var wrapped_angle := wrapf(dir.angle_to(cardinal_dir), 0.0, TAU)
		var angle_diff_magnitude: float = min(wrapped_angle, TAU - wrapped_angle)
		# Some tolerance here for the diagonal behavior described above.
		if angle_diff_magnitude + .01 < smallest_angle:
			smallest_angle = angle_diff_magnitude
			closest_cardinal_dir = cardinal_dir

	var animation: String
	match closest_cardinal_dir:
		Vector2.UP:
			animation = "interact_up"
		Vector2.RIGHT:
			animation = "interact_right"
		Vector2.DOWN:
			animation = "interact_down"
		Vector2.LEFT:
			animation = "interact_right"

	assert(animation != "", "Could not find interact animation.")
	return animation
