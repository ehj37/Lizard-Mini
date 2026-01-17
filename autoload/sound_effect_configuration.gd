class_name SoundEffectConfiguration

extends Resource

enum Type {
	PLAYER_DASH,
	PLAYER_FOOTSTEP,
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
	PROGRESS_INDICATOR_SHORT
}

enum LimitBehavior { REPLACE_OLD, NOOP }

@export var type: Type
@export var limit: int = 1
@export var limit_behavior: LimitBehavior = LimitBehavior.REPLACE_OLD
@export var pitch_variance: float = 0.0
@export var audio_stream: AudioStreamOggVorbis
