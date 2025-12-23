extends Node2D

@export var sound_effect_configs: Array[SoundEffectConfiguration]

var _sound_effect_configs: Dictionary = {}
var _audio_players_by_type: Dictionary = {}


func _ready() -> void:
	for sound_effect_type in SoundEffectConfiguration.Type.values():
		var config_i = sound_effect_configs.find_custom(func(c): return c.type == sound_effect_type)
		if config_i == -1:
			continue

		var config = sound_effect_configs[config_i]
		_sound_effect_configs[config.type] = config
		_audio_players_by_type[config.type] = []


func play_effect_at(global_pos: Vector2, type: SoundEffectConfiguration.Type) -> void:
	var config = _sound_effect_configs.get(type)
	assert(config != null, "Sound effect must be defined in AudioManager")

	config = config as SoundEffectConfiguration
	var audio_players_for_type = _audio_players_by_type[type] as Array[AudioStreamPlayer2D]
	var sound_effect_count = audio_players_for_type.size()
	if sound_effect_count > config.limit:
		match config.limit_behavior:
			SoundEffectConfiguration.LimitBehavior.NOOP:
				return
			SoundEffectConfiguration.LimitBehavior.REPLACE_OLD:
				var oldest_audio_player = audio_players_for_type.pop_front()
				oldest_audio_player.queue_free()

	var audio_player = AudioStreamPlayer2D.new()
	add_child(audio_player)
	audio_player.global_position = global_pos
	audio_player.stream = config.audio_stream
	var min_pitch_scale = 1.0 - config.pitch_variance
	var max_pitch_scale = 1.0 + config.pitch_variance
	audio_player.pitch_scale = randf_range(min_pitch_scale, max_pitch_scale)
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.play()

	_audio_players_by_type[type].append(audio_player)
	audio_player.finished.connect(
		func(): _audio_players_by_type[type].erase(audio_player) ; audio_player.queue_free()
	)


func cancel_audio(type: SoundEffectConfiguration.Type) -> void:
	var audio_players = _audio_players_by_type[type]
	for audio_player: AudioStreamPlayer2D in audio_players:
		audio_player.queue_free()

	_audio_players_by_type[type].clear()
