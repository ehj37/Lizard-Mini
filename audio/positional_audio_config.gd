class_name PositionalAudioConfig

extends Resource

enum Type {
	CANISTER_AMBIENCE,
	CANISTER_EXPLOSION,
	DOOR_DOWN,
	FIRE_VENT,
	INTERACT_COMPLETE,
	POT_BREAK,
	PROGRESS_INDICATOR_MEDIUM,
	PROGRESS_INDICATOR_SHORT,
	SINGE,
	STATUETTE_BREAK,
	WISP_ALERT,
	WISP_CONTAINER_BREAK,
	WISP_DEATH,
	CORVID_ATTACK,
	CORVID_DEATH,
	CORVID_ALERT,
	WIP_ENEMY_SLAM
}

enum LimitBehavior { REPLACE_OLD, NOOP }

@export var type: Type
# The max number of times this effect can be played at once. Set to -1 if there
# should not be a limit.
@export var limit: int = 1
@export var limit_behavior: LimitBehavior = LimitBehavior.REPLACE_OLD
@export var pitch_variance: float = 0.0
@export var audio_stream: AudioStreamOggVorbis
# Best used for effects that loop.
@export var random_start_time: bool = false
@export var loop_audio: bool = false
