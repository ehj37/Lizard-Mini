extends PlayerState

const MAX_MOVE_SPEED := 80.0
const MOVE_ACCELERATION := 360.0
const FOOTSTEP_PITCH_VARIANCE := 0.1

var _move_speed := 0.0
var _ground_tilemap_layers: Array[TileMapLayer] = []

@onready var footstep_dust_cloud_resource := preload(
	"res://scenes/player/footstep_dust_cloud/footstep_dust_cloud.tscn"
)
@onready var dust_cloud_timer: Timer = $DustCloudTimer


func update(delta: float) -> void:
	var movement_dir = player.get_movement_direction()

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash") && player.dash_cooldown_timer.is_stopped():
		state_machine.transition_to("Dash")
		return

	if Input.is_action_just_pressed("interact"):
		var interact_area = InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
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
	if _ground_tilemap_layers.size() == 0:
		var ground_nodes = get_tree().get_nodes_in_group("ground")
		for ground_node in ground_nodes:
			if ground_node is TileMapLayer:
				_ground_tilemap_layers.append(ground_node)

	_move_speed = 0.0
	var animation = _get_animation(player.orientation)
	animation_player.play(animation)
	dust_cloud_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()
	dust_cloud_timer.stop()


func play_footstep_sound_effect() -> void:
	var tile_data = []
	for tilemap_layer: TileMapLayer in _ground_tilemap_layers:
		var tile_position = tilemap_layer.local_to_map(player.position)
		var data_at_position = tilemap_layer.get_cell_tile_data(tile_position)
		if data_at_position:
			tile_data.append(data_at_position)

	var effect_type = SoundEffectConfiguration.Type.PLAYER_FOOTSTEP_TILE

	if tile_data.size() > 0:
		var tile_type = tile_data.back().get_custom_data("ground_type")
		match tile_type:
			"tile":
				effect_type = SoundEffectConfiguration.Type.PLAYER_FOOTSTEP_TILE
			"clay":
				effect_type = SoundEffectConfiguration.Type.PLAYER_FOOTSTEP_CLAY

	AudioManager.play_effect_at(player.global_position, effect_type)


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
			animation = "run_right"
		Vector2.DOWN:
			animation = "run_down"
		Vector2.LEFT:
			animation = "run_right"

	assert(animation != "", "Could not match direction to run animation.")
	return animation


func _on_dust_cloud_timer_timeout():
	var dust_cloud = footstep_dust_cloud_resource.instantiate()
	dust_cloud.global_position = player.global_position
	dust_cloud.flip_h = player.sprite.flip_h
	player.owner.add_child(dust_cloud)

	dust_cloud_timer.start()
