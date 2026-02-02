extends Node2D

const AUDIO_STREAM_PLAYER_MAX_DISTANCE := 500

@export var sound_effect_configs: Array[SoundEffectConfiguration]

var _sound_effect_configs: Dictionary = {}
var _audio_players_by_type: Dictionary = {}


func _ready() -> void:
	for sound_effect_type: SoundEffectConfiguration.Type in SoundEffectConfiguration.Type.values():
		var config_i: int = sound_effect_configs.find_custom(
			func(c: SoundEffectConfiguration) -> bool: return c.type == sound_effect_type
		)
		assert(
			config_i != -1,
			"Sound effect " + str(sound_effect_type) + " must be defined in AudioManager"
		)

		var config: SoundEffectConfiguration = sound_effect_configs[config_i]
		_sound_effect_configs[config.type] = config
		_audio_players_by_type[config.type] = []


# Returns an identifier that can be used to cancel the sound with, or -1 if the
# sound was not played.
func play_effect_at(
	global_pos: Vector2, type: SoundEffectConfiguration.Type, pitch_multiplier: float = 1.0
) -> int:
	var config: SoundEffectConfiguration = _sound_effect_configs.get(type)
	assert(config != null, "Sound effect must be defined in AudioManager")

	var audio_players_for_type: Array = _audio_players_by_type[type]
	var sound_effect_count: int = audio_players_for_type.size()
	if config.limit != -1 && sound_effect_count > config.limit:
		match config.limit_behavior:
			SoundEffectConfiguration.LimitBehavior.NOOP:
				return -1
			SoundEffectConfiguration.LimitBehavior.REPLACE_OLD:
				var oldest_audio_player: AudioStreamPlayer2D = audio_players_for_type.pop_front()
				oldest_audio_player.queue_free()

	var audio_player := AudioStreamPlayer2D.new()
	audio_player.max_distance = AUDIO_STREAM_PLAYER_MAX_DISTANCE
	add_child(audio_player)
	audio_player.global_position = global_pos
	var audio_stream := config.audio_stream
	if config.loop_audio:
		audio_stream.loop = true
	audio_player.stream = audio_stream
	var start_time := 0.0
	if config.random_start_time:
		var stream_length := audio_player.stream.get_length()
		start_time = randf_range(0.0, stream_length)

	var min_pitch_scale := 1.0 - config.pitch_variance
	var max_pitch_scale := 1.0 + config.pitch_variance
	audio_player.pitch_scale = pitch_multiplier * randf_range(min_pitch_scale, max_pitch_scale)
	audio_player.finished.connect(func() -> void: audio_player.queue_free())
	audio_player.play(start_time)

	var audio_players: Array = _audio_players_by_type[type]
	audio_players.append(audio_player)
	audio_player.finished.connect(
		func() -> void: audio_players.erase(audio_player) ; audio_player.queue_free()
	)

	return audio_player.get_instance_id()


func cancel_audio(type: SoundEffectConfiguration.Type, identifier: int = -1) -> void:
	var audio_players: Array = _audio_players_by_type[type]
	if identifier == -1:
		for audio_player: AudioStreamPlayer2D in audio_players:
			audio_player.queue_free()

		audio_players.clear()
	else:
		var kill_index := audio_players.find_custom(
			func(audio_player: AudioStreamPlayer2D) -> bool: return (
				audio_player.get_instance_id() == identifier
			)
		)
		if kill_index == -1:
			return

		var audio_player_to_kill: AudioStreamPlayer2D = audio_players[kill_index]
		audio_players.erase(audio_player_to_kill)
		audio_player_to_kill.queue_free()
