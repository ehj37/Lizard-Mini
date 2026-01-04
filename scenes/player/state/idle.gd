extends PlayerState

@onready var impatient_timer: Timer = $ImpatientTimer
@onready var sit_timer: Timer = $SitTimer


func update(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if Input.is_action_just_pressed("interact"):
		var interact_area = InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
			return

	var movement_direction = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		state_machine.transition_to("Run")


func enter(data := {}):
	player.velocity = Vector2.ZERO

	var animation = _get_animation(player.orientation)
	animation_player.play(animation)

	player.sprite.flip_h = player.orientation.x < 0

	var impatient = data.get("impatient", false)
	if !impatient:
		impatient_timer.start()
	else:
		sit_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	impatient_timer.stop()
	sit_timer.stop()


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
			return "idle_right"
		Vector2.DOWN:
			return "idle_down"
		_:
			return "idle_right"


func _on_impatient_timer_timeout():
	state_machine.transition_to("Impatient")


func _on_sit_timer_timeout():
	state_machine.transition_to("Sit")
