extends PlayerState

var _most_recent_animation: String


func update(_delta: float) -> void:
	var movement_dir := player.get_movement_direction()

	if movement_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	player.orientation = movement_dir

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if Input.is_action_just_pressed("interact"):
		var interact_area := InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
			return

	if player.ledge_detector.on_ledge(movement_dir):
		_update_sprite(movement_dir)
		return

	state_machine.transition_to("Run")


func enter(_data := {}) -> void:
	player.velocity = Vector2.ZERO
	_most_recent_animation = ""
	_update_sprite(player.get_movement_direction())


func _update_sprite(movement_direction: Vector2) -> void:
	player.sprite.flip_h = movement_direction.x < 0

	var smallest_angle := INF
	var closest_cardinal_dir: Vector2
	# Order matters here for diagonal tiebreaking.
	# Favoring horizontal ledge peer animations over vertical.
	for cardinal_dir: Vector2 in [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]:
		var wrapped_angle := wrapf(movement_direction.angle_to(cardinal_dir), 0.0, TAU)
		var angle_diff_magnitude: float = min(wrapped_angle, TAU - wrapped_angle)
		# Some tolerance here for the diagonal behavior described above.
		if angle_diff_magnitude + .01 < smallest_angle:
			smallest_angle = angle_diff_magnitude
			closest_cardinal_dir = cardinal_dir

	var animation: String
	match closest_cardinal_dir:
		Vector2.UP:
			animation = "ledge_peer_up"
		Vector2.RIGHT:
			animation = "ledge_peer_right"
		Vector2.DOWN:
			animation = "ledge_peer_down"
		_:
			animation = "ledge_peer_right"

	if _most_recent_animation != animation:
		animation_player.current_animation = animation
		_most_recent_animation = animation
