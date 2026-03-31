extends PlayerState

const MAX_MOVE_SPEED: float = 80.0
const MOVE_ACCELERATION: float = 360.0
const FOOTSTEP_PITCH_VARIANCE: float = 0.1

var _move_speed: float = 0.0
var _ground_tilemap_layers: Array[TileMapLayer] = []

@onready var footstep_dust_cloud_resource: PackedScene = preload(
	"res://scenes/player/footstep_dust_cloud/footstep_dust_cloud.tscn"
)
@onready var dust_cloud_timer: Timer = $DustCloudTimer
@onready var animation_map: Dictionary = {
	Vector2.UP.angle(): "run_up",
	Vector2.RIGHT.angle(): "run_right",
	Vector2.DOWN.angle(): "run_down",
	Vector2.LEFT.angle(): "run_right"
}
@onready var _footstep_clay_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_footstep_clay.tres"
)
@onready var _footstep_tile_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_footstep_tile.tres"
)


func update(delta: float) -> void:
	var ground_detector_status: PlayerGroundDetector.Status = (
		player.ground_detector.current_status()
	)
	if ground_detector_status == PlayerGroundDetector.Status.NOT_GROUNDED:
		state_machine.transition_to("FallPit")
		return

	if ground_detector_status == PlayerGroundDetector.Status.ON_SAFE_GROUND:
		player.last_safe_global_position = player.global_position

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash") && player.dash_cooldown_timer.is_stopped():
		state_machine.transition_to("Dash")
		return

	if Input.is_action_just_pressed("interact"):
		var interact_area: InteractArea = InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
			return

	var movement_dir: Vector2 = player.get_movement_direction()

	if player.ground_detector.on_ledge(movement_dir):
		state_machine.transition_to("LedgePeer")
		return

	if movement_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	var animation: String = _get_animation(movement_dir)
	if animation_player.current_animation != animation:
		animation_player.current_animation = animation

	_move_speed = min(_move_speed + MOVE_ACCELERATION * delta, MAX_MOVE_SPEED)

	player.sprite.flip_h = movement_dir.x < 0
	player.velocity = movement_dir * _move_speed
	player.orientation = movement_dir


func enter(_data: Dictionary = {}) -> void:
	if _ground_tilemap_layers.size() == 0:
		var ground_nodes: Array[Node] = get_tree().get_nodes_in_group("ground")
		for ground_node: Node2D in ground_nodes:
			if ground_node is TileMapLayer:
				_ground_tilemap_layers.append(ground_node)

	_move_speed = 0.0
	var animation: String = _get_animation(player.orientation)
	animation_player.play(animation)
	dust_cloud_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()
	dust_cloud_timer.stop()


func play_footstep_sound_effect() -> void:
	var tile_data: Array[TileData] = []
	for tilemap_layer: TileMapLayer in _ground_tilemap_layers:
		var tile_position: Vector2i = tilemap_layer.local_to_map(player.position)
		var data_at_position: TileData = tilemap_layer.get_cell_tile_data(tile_position)
		if data_at_position:
			tile_data.append(data_at_position)

	var sound_effect_config: SoundEffectConfig = _footstep_tile_sound_effect_config
	if tile_data.size() > 0:
		var uppermost_tile_data: TileData = tile_data.back()
		var tile_type: String = uppermost_tile_data.get_custom_data("ground_type")
		match tile_type:
			"tile":
				sound_effect_config = _footstep_tile_sound_effect_config
			"clay":
				sound_effect_config = _footstep_clay_sound_effect_config

	SoundEffectManager.play(sound_effect_config)


func _get_animation(dir: Vector2) -> String:
	return AnimationPicker.pick_animation(animation_map, dir.angle())


func _on_dust_cloud_timer_timeout() -> void:
	var dust_cloud: Sprite2D = footstep_dust_cloud_resource.instantiate()
	dust_cloud.global_position = player.global_position
	dust_cloud.flip_h = player.sprite.flip_h
	LevelManager.current_level.add_child(dust_cloud)

	dust_cloud_timer.start()
