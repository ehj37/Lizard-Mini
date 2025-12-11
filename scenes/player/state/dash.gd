extends PlayerState

const DASH_SPEED := 250.0
const MOVEMENT_DURATION := 0.2

var _dash_direction: Vector2

@onready var dash_ghost_resource := preload("res://scenes/player/dash_ghost/dash_ghost.tscn")
@onready var ghost_timer: Timer = $GhostTimer


func update(_delta: float) -> void:
	player.velocity = _dash_direction * DASH_SPEED


func enter(_data := {}):
	var movement_dir = player.get_movement_direction()
	if movement_dir == Vector2.ZERO:
		_dash_direction = player.orientation
	else:
		_dash_direction = movement_dir

	player.velocity = _dash_direction * DASH_SPEED
	get_tree().create_timer(MOVEMENT_DURATION).timeout.connect(_stop)

	player.sprite.flip_h = _dash_direction.x < 0
	player.orientation = _dash_direction
	var animation = _get_animation(_dash_direction)
	animation_player.play(animation)
	if player.orientation.x < 0:
		player.sprite.flip_h = true

	_spawn_ghost()
	ghost_timer.start()

	player.hurtbox.disable()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	ghost_timer.stop()
	player.velocity = Vector2.ZERO
	player.hurtbox.enable()


func _stop():
	if !is_current_state():
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	var movement_dir = player.get_movement_direction()
	if movement_dir != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


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
			animation = "dash_up"
		Vector2.RIGHT:
			animation = "dash_side"
		Vector2.DOWN:
			animation = "dash_down"
		Vector2.LEFT:
			animation = "dash_side"

	assert(animation != "", "Could not match direction to dash animation.")
	return animation


func _spawn_ghost() -> void:
	var dash_ghost = dash_ghost_resource.instantiate() as PlayerDashGhost
	dash_ghost.global_position = player.global_position
	dash_ghost.direction = _dash_direction
	dash_ghost.animation = _get_animation(_dash_direction)
	dash_ghost.flip_h = player.sprite.flip_h
	player.owner.add_child(dash_ghost)
