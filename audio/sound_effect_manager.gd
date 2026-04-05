extends Node2D

const AUDIO_STREAM_PLAYER_MAX_DISTANCE: float = 500

var _audio_players_by_resource_path: Dictionary = {}
var _audio_player_to_resource_path: Dictionary = {}
var _instance_id_to_audio_player: Dictionary = {}


func play(config: SoundEffectConfig) -> int:
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

	# So audio keeps playing during hit stop
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	audio_player.bus = "SoundEffects"
	add_child(audio_player)

	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	audio_stream.loop = config.loop_audio
	audio_player.stream = audio_stream
	var start_time: float = 0.0
	if config.random_start_time:
		var stream_length: float = audio_player.stream.get_length()
		start_time = randf_range(0.0, stream_length)

	audio_player.finished.connect(func() -> void: _remove_audio_player(audio_player))
	audio_player.play(start_time)

	var resource_path: String = config.resource_path
	if !_audio_players_by_resource_path.has(resource_path):
		_audio_players_by_resource_path[resource_path] = []

	var same_config_audio_players: Array = _audio_players_by_resource_path.get(resource_path)
	same_config_audio_players.append(audio_player)

	_audio_player_to_resource_path[audio_player] = resource_path

	var instance_id: int = audio_player.get_instance_id()
	_instance_id_to_audio_player[instance_id] = audio_player

	if config.limit != -1:
		var audio_count: int = same_config_audio_players.size()
		if audio_count > config.limit:
			match config.limit_behavior:
				SoundEffectConfig.LimitBehavior.NOOP:
					return -1
				SoundEffectConfig.LimitBehavior.REPLACE_OLD:
					var oldest_audio_player: AudioStreamPlayer = (
						same_config_audio_players.pop_front()
					)
					_remove_audio_player(oldest_audio_player)

	return instance_id


func play_at(config: SoundEffectConfig, effect_position: Vector2) -> int:
	var audio_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio_player.max_distance = AUDIO_STREAM_PLAYER_MAX_DISTANCE
	# So audio keeps playing during hit stop
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	audio_player.bus = "SoundEffects"
	add_child(audio_player)

	audio_player.global_position = effect_position
	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	if config.loop_audio:
		audio_stream.loop = true
	audio_player.stream = audio_stream
	var start_time: float = 0.0
	if config.random_start_time:
		var stream_length: float = audio_player.stream.get_length()
		start_time = randf_range(0.0, stream_length)

	audio_player.finished.connect(func() -> void: _remove_audio_player_2d(audio_player))
	audio_player.play(start_time)

	var resource_path: String = config.resource_path
	if !_audio_players_by_resource_path.has(resource_path):
		_audio_players_by_resource_path[resource_path] = []

	var same_config_audio_players: Array = _audio_players_by_resource_path.get(resource_path)
	same_config_audio_players.append(audio_player)

	_audio_player_to_resource_path[audio_player] = resource_path

	var instance_id: int = audio_player.get_instance_id()
	_instance_id_to_audio_player[instance_id] = audio_player

	if config.limit != -1:
		var audio_count: int = same_config_audio_players.size()
		if audio_count > config.limit:
			match config.limit_behavior:
				SoundEffectConfig.LimitBehavior.NOOP:
					return -1
				SoundEffectConfig.LimitBehavior.REPLACE_OLD:
					var oldest_audio_player: AudioStreamPlayer2D = (
						same_config_audio_players.pop_front()
					)
					_remove_audio_player_2d(oldest_audio_player)

	return instance_id


func cancel(instance_id: int) -> void:
	if !_instance_id_to_audio_player.has(instance_id):
		return

	@warning_ignore("untyped_declaration")
	var audio_player = _instance_id_to_audio_player.get(instance_id)
	if audio_player is AudioStreamPlayer:
		@warning_ignore("unsafe_cast")
		_remove_audio_player(audio_player as AudioStreamPlayer)
	else:
		@warning_ignore("unsafe_cast")
		_remove_audio_player_2d(audio_player as AudioStreamPlayer2D)


func _remove_audio_player(audio_player: AudioStreamPlayer) -> void:
	var resource_path: String = _audio_player_to_resource_path.get(audio_player)
	if resource_path == null:
		push_error("Attempting to remove audio player not in _audio_player_to_resource_path")

	var same_config_audio_players: Array = _audio_players_by_resource_path.get(resource_path, [])
	same_config_audio_players.erase(audio_player)
	_audio_player_to_resource_path.erase(audio_player)
	_instance_id_to_audio_player.erase(audio_player.get_instance_id())
	audio_player.queue_free()


func _remove_audio_player_2d(audio_player: AudioStreamPlayer2D) -> void:
	var resource_path: String = _audio_player_to_resource_path.get(audio_player)
	if resource_path == null:
		push_error("Attempting to remove audio player not in _audio_player_to_resource_path")

	var same_config_audio_players: Array = _audio_players_by_resource_path.get(resource_path, [])
	same_config_audio_players.erase(audio_player)
	_audio_player_to_resource_path.erase(audio_player)
	_instance_id_to_audio_player.erase(audio_player.get_instance_id())
	audio_player.queue_free()
