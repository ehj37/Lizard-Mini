extends PlayerState

const DASH_SPEED := 400.0
const MOVEMENT_DURATION := 0.18
const CHAIN_ATTACK_WINDOW_START := 0.25
const CHAIN_DASH_WINDOW_START := 0.3
const PITCH_MULTIPLIER_PER_DASH := 0.05
const MAX_PITCH_MULTIPLIER := 1.2

var _dash_direction: Vector2
var _dash_num: int
var _in_move_window: bool
var _in_chain_attack_window: bool
var _in_chain_dash_window: bool
var _dash_attempted_before_dash_window: bool

@onready var dash_ghost_resource := preload("res://scenes/player/dash_ghost/dash_ghost.tscn")
@onready var ghost_timer: Timer = $GhostTimer


func update(_delta: float) -> void:
	if _in_move_window:
		player.velocity = _dash_direction * DASH_SPEED
	else:
		player.velocity = Vector2.ZERO

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		if _in_chain_attack_window:
			state_machine.transition_to("Attack")
			return

	if Input.is_action_just_pressed("dash"):
		if _in_chain_dash_window:
			# Punish spamming dash too early by not allowing a chain dash.
			if !_dash_attempted_before_dash_window:
				state_machine.transition_to("Dash", {"dash_num": _dash_num + 1})
				return
		else:
			_dash_attempted_before_dash_window = true

	if animation_player.is_playing():
		return

	var movement_dir := player.get_movement_direction()
	if movement_dir != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(data := {}) -> void:
	var movement_dir := player.get_movement_direction()
	if movement_dir == Vector2.ZERO:
		if player.orientation == Vector2.ZERO:
			_dash_direction = Vector2.RIGHT
		else:
			_dash_direction = player.orientation
	else:
		_dash_direction = movement_dir
	player.velocity = _dash_direction * DASH_SPEED

	_in_move_window = true
	get_tree().create_timer(MOVEMENT_DURATION).timeout.connect(_exit_movement_window)

	_in_chain_attack_window = false
	get_tree().create_timer(CHAIN_ATTACK_WINDOW_START).timeout.connect(_enter_chain_attack_window)

	_in_chain_dash_window = false
	_dash_attempted_before_dash_window = false
	get_tree().create_timer(CHAIN_DASH_WINDOW_START).timeout.connect(_enter_chain_dash_window)

	player.sprite.flip_h = _dash_direction.x < 0
	player.orientation = _dash_direction

	var animation := _get_animation(_dash_direction)
	animation_player.play(animation)
	if player.orientation.x < 0:
		player.sprite.flip_h = true

	_dash_num = data.get("dash_num", 0)
	var pitch_multiplier := minf(1.0 + PITCH_MULTIPLIER_PER_DASH * _dash_num, MAX_PITCH_MULTIPLIER)
	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_DASH, pitch_multiplier
	)

	_spawn_ghost()
	ghost_timer.start()

	player.hurtbox.disable()
	player.hurtbox_feet.disable()
	player.hitbox_feet.enable()

	player.clear_burn()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	ghost_timer.stop()
	player.velocity = Vector2.ZERO
	player.hurtbox.enable()
	player.hurtbox_feet.enable()
	player.hitbox_feet.disable()

	# For chain dashes, we don't check the cooldown timer, so this is fine.
	player.dash_cooldown_timer.start()


func _exit_movement_window() -> void:
	if !is_current_state():
		return

	_in_move_window = false
	player.velocity = Vector2.ZERO
	player.hurtbox.enable()
	player.hurtbox_feet.enable()
	player.hitbox_feet.disable()
	ghost_timer.stop()


func _enter_chain_attack_window() -> void:
	if !is_current_state():
		return

	_in_chain_attack_window = true


func _enter_chain_dash_window() -> void:
	if !is_current_state():
		return

	_in_chain_dash_window = true


func _get_animation(dir: Vector2) -> String:
	var smallest_angle := INF
	var closest_cardinal_dir: Vector2
	# Order matters here for diagonal tiebreaking.
	# Favoring horizontal run animations over vertical.
	for cardinal_dir: Vector2 in [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]:
		var wrapped_angle := wrapf(dir.angle_to(cardinal_dir), 0.0, TAU)
		var angle_diff_magnitude: float = min(wrapped_angle, TAU - wrapped_angle)
		# Some tolerance here for the diagonal behavior described above.
		if angle_diff_magnitude + .01 < smallest_angle:
			smallest_angle = angle_diff_magnitude
			closest_cardinal_dir = cardinal_dir

	var animation: String = ""
	match closest_cardinal_dir:
		Vector2.UP:
			animation = "dash_up"
		Vector2.RIGHT:
			animation = "dash_right"
		Vector2.DOWN:
			animation = "dash_down"
		Vector2.LEFT:
			animation = "dash_right"

	assert(animation != "", "Could not match direction to dash animation.")
	return animation


func _spawn_ghost() -> void:
	var dash_ghost: PlayerDashGhost = dash_ghost_resource.instantiate()
	dash_ghost.global_position = player.global_position
	dash_ghost.direction = _dash_direction
	dash_ghost.animation = _get_animation(_dash_direction)
	dash_ghost.flip_h = player.sprite.flip_h
	LevelManager.current_level.add_child(dash_ghost)
