extends PlayerState

const MAX_MOVE_SPEED := 80.0
const MOVE_ACCELERATION := 360.0
const FOOTSTEP_PITCH_VARIANCE := 0.1

var _move_speed := 0.0

@onready var footstep_dust_cloud_resource := preload(
	"res://scenes/player/footstep_dust_cloud/footstep_dust_cloud.tscn"
)
@onready var footstep_sound := preload("res://scenes/player/sound_effects/footsteps.ogg")
@onready var dust_cloud_timer: Timer = $DustCloudTimer


func update(delta: float) -> void:
	var movement_dir = player.get_movement_direction()

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash") && player.dash_cooldown_timer.is_stopped():
		state_machine.transition_to("Dash")
		return

	if movement_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	var animation = _get_animation(movement_dir)
	if animation_player.current_animation != animation:
		animation_player.current_animation = animation

	_move_speed = min(_move_speed + MOVE_ACCELERATION * delta, MAX_MOVE_SPEED)

	player.sprite.flip_h = movement_dir.x < 0
	player.velocity = movement_dir * _move_speed
	player.orientation = movement_dir


func enter(_data := {}) -> void:
	_move_speed = 0.0
	var animation = _get_animation(player.orientation)
	animation_player.play(animation)
	dust_cloud_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()
	dust_cloud_timer.stop()


func play_footstep_sound_effect() -> void:
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.global_position = player.global_position
	audio_player.stream = footstep_sound
	player.owner.add_child(audio_player)
	audio_player.play()
	audio_player.pitch_scale = randf_range(
		1.0 - FOOTSTEP_PITCH_VARIANCE, 1.0 + FOOTSTEP_PITCH_VARIANCE
	)
	audio_player.finished.connect(func(): audio_player.queue_free())


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


func _on_dust_cloud_timer_timeout():
	var dust_cloud = footstep_dust_cloud_resource.instantiate()
	dust_cloud.global_position = player.global_position
	dust_cloud.flip_h = player.sprite.flip_h
	player.owner.add_child(dust_cloud)

	dust_cloud_timer.start()
