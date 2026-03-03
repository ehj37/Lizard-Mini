extends Node

@export var audio_configs: Array[NonPositionalAudioConfig]

var _audio_configs_by_type: Dictionary = {}
var _audio_players_by_type: Dictionary = {}


func _ready() -> void:
	for audio_config_type: NonPositionalAudioConfig.Type in NonPositionalAudioConfig.Type.values():
		var config_i: int = audio_configs.find_custom(
			func(c: NonPositionalAudioConfig) -> bool: return c.type == audio_config_type
		)
		assert(
			config_i != -1,
			(
				"Audio config "
				+ NonPositionalAudioConfig.Type.keys()[audio_config_type]
				+ " must be defined in NonPositionalAudioManager"
			)
		)

		var config: NonPositionalAudioConfig = audio_configs[config_i]
		_audio_configs_by_type[config.type] = config
		_audio_players_by_type[config.type] = []


# Returns an identifier that can be used to cancel the audio with, or -1 if the
# audio was not played.
func play_audio(type: NonPositionalAudioConfig.Type, pitch_multiplier: float = 1.0) -> int:
	var config: NonPositionalAudioConfig = _audio_configs_by_type.get(type)
	assert(config != null, "Audio must be defined in NonPositionalAudioManager")

	var audio_players_for_type: Array = _audio_players_by_type[type]
	var audio_count: int = audio_players_for_type.size()
	if config.limit != -1 && audio_count > config.limit:
		match config.limit_behavior:
			NonPositionalAudioConfig.LimitBehavior.NOOP:
				return -1
			NonPositionalAudioConfig.LimitBehavior.REPLACE_OLD:
				var oldest_audio_player: AudioStreamPlayer = audio_players_for_type.pop_front()
				oldest_audio_player.queue_free()

	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

	# So audio keeps playing during hit stop
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)

	var audio_stream: AudioStreamOggVorbis = config.audio_stream
	audio_stream.loop = config.loop_audio
	audio_player.stream = audio_stream
	var start_time: float = 0.0
	if config.random_start_time:
		var stream_length: float = audio_player.stream.get_length()
		start_time = randf_range(0.0, stream_length)

	var min_pitch_scale: float = 1.0 - config.pitch_variance
	var max_pitch_scale: float = 1.0 + config.pitch_variance
	audio_player.pitch_scale = pitch_multiplier * randf_range(min_pitch_scale, max_pitch_scale)
	audio_player.finished.connect(func() -> void: audio_player.queue_free())
	audio_player.play(start_time)

	var audio_players: Array = _audio_players_by_type[type]
	audio_players.append(audio_player)
	audio_player.finished.connect(
		func() -> void: audio_players.erase(audio_player) ; audio_player.queue_free()
	)

	return audio_player.get_instance_id()


func cancel_audio(type: NonPositionalAudioConfig.Type, identifier: int = -1) -> void:
	var audio_players: Array = _audio_players_by_type[type]
	if identifier == -1:
		for audio_player: AudioStreamPlayer in audio_players:
			audio_player.queue_free()

		audio_players.clear()
	else:
		var kill_index: int = audio_players.find_custom(
			func(audio_player: AudioStreamPlayer) -> bool: return (
				audio_player.get_instance_id() == identifier
			)
		)
		if kill_index == -1:
			return

		var audio_player_to_kill: AudioStreamPlayer = audio_players[kill_index]
		audio_players.erase(audio_player_to_kill)
		audio_player_to_kill.queue_free()
