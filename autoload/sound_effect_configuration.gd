class_name SoundEffectConfiguration

extends Resource

enum Type {
	PLAYER_DASH,
	PLAYER_FOOTSTEP_TILE,
	PLAYER_SWORD_SWING,
	POT_BREAK,
	WISP_DEATH,
	CANISTER_EXPLOSION,
	PROGRESS_INDICATOR_MEDIUM,
	DOOR_DOWN,
	PLAYER_FALL_THUD,
	PLAYER_OUCH,
	SINGE,
	WISP_ALERT,
	PROGRESS_INDICATOR_SHORT,
	STATUETTE_BREAK,
	PLAYER_FOOTSTEP_CLAY,
	PLAYER_BLINK,
	CANISTER_AMBIENCE,
	FIRE_VENT,
	PLAYER_FALL_PIT,
	WISP_CONTAINER_BREAK,
	INTERACT_COMPLETE
}

enum LimitBehavior { REPLACE_OLD, NOOP }

@export var type: Type
# The max number of times this effect can be played at once. Set to -1 if there
# should not be a limit.
@export var limit := 1
@export var limit_behavior := LimitBehavior.REPLACE_OLD
@export var pitch_variance := 0.0
@export var audio_stream: AudioStreamOggVorbis
# Best used for effects that loop.
@export var random_start_time := false
@export var loop_audio := false
