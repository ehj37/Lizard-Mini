class_name InteractArea

extends Area2D

signal interaction_complete

enum InteractionLength { SHORT, MEDIUM }

const INTERACTION_LENGTH_DURATIONS: Dictionary = {
	InteractionLength.SHORT: 1.0, InteractionLength.MEDIUM: 2.0
}

@export var interaction_length: InteractionLength = InteractionLength.MEDIUM
@export var progress_indicator: ProgressIndicator

var _completion_progress: float = 0.0
var _progress_sound_effect_identifier: int

@onready var interaction_progress_short_sound_effect_config: SoundEffectConfig = preload(
	"res://audio/shared_sound_effects/interaction/interaction_progress_short.tres"
)
@onready var interaction_progress_medium_sound_effect_config: SoundEffectConfig = preload(
	"res://audio/shared_sound_effects/interaction/interaction_progress_medium.tres"
)
@onready var interaction_complete_sound_effect_config: SoundEffectConfig = preload(
	"res://audio/shared_sound_effects/interaction/interaction_complete.tres"
)


func interact(delta: float) -> void:
	if _completion_progress == 0.0:
		_progress_sound_effect_identifier = SoundEffectManager.play_at(
			_get_interact_progress_sound_effect_config(), global_position
		)

	var completion_time: float = INTERACTION_LENGTH_DURATIONS[interaction_length]
	_completion_progress = min(_completion_progress + delta, completion_time)
	var completion_percentage: float = _completion_progress / completion_time
	progress_indicator.update_progress_bar(completion_percentage * 100.0)
	if _completion_progress == completion_time:
		interaction_complete.emit()
		SoundEffectManager.play_at(interaction_complete_sound_effect_config, global_position)
		disable()


func reset_progress() -> void:
	_completion_progress = 0.0
	SoundEffectManager.cancel(_progress_sound_effect_identifier)
	progress_indicator.update_progress_bar(0.0)


func enable() -> void:
	reset_progress()
	monitoring = true


func disable() -> void:
	monitoring = false


func _on_body_entered(_body: Node2D) -> void:
	progress_indicator.fade_in()
	InteractionManager.register_area(self)


func _on_body_exited(_body: Node2D) -> void:
	progress_indicator.fade_out()
	InteractionManager.unregister_area(self)


func _get_interact_progress_sound_effect_config() -> SoundEffectConfig:
	match interaction_length:
		InteractionLength.SHORT:
			return interaction_progress_short_sound_effect_config
		InteractionLength.MEDIUM:
			return interaction_progress_medium_sound_effect_config
		_:
			assert(false, "Interaction length does not have corresponding audio config type")
			return interaction_progress_short_sound_effect_config
