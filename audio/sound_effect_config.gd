class_name SoundEffectConfig

extends Resource

enum LimitBehavior { REPLACE_OLD, NOOP }

# The max number of times this effect can be played at once. Set to -1 if there
# should not be a limit.
@export var limit: int = 1
@export var limit_behavior: LimitBehavior = LimitBehavior.REPLACE_OLD
@export var pitch_variance: float = 0.0
@export var audio_stream: AudioStreamOggVorbis
# Best used for effects that loop.
@export var random_start_time: bool = false
@export var loop_audio: bool = false
