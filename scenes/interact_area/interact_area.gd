class_name InteractArea

extends Area2D

signal interaction_complete

enum InteractionLength { SHORT, MEDIUM }

const INTERACTION_LENGTH_DURATIONS := {InteractionLength.SHORT: 1.0, InteractionLength.MEDIUM: 2.0}

@export var interaction_length := InteractionLength.MEDIUM
@export var progress_indicator: ProgressIndicator

var _completion_progress := 0.0


func interact(delta: float) -> void:
	if _completion_progress == 0.0:
		AudioManager.play_effect_at(global_position, _get_sound_effect())

	var completion_time: float = INTERACTION_LENGTH_DURATIONS[interaction_length]
	_completion_progress = min(_completion_progress + delta, completion_time)
	var completion_percentage := _completion_progress / completion_time
	progress_indicator.update_progress_bar(completion_percentage * 100.0)
	if _completion_progress == completion_time:
		interaction_complete.emit()
		AudioManager.play_effect_at(
			global_position, SoundEffectConfiguration.Type.INTERACT_COMPLETE
		)
		disable()


func reset_progress() -> void:
	_completion_progress = 0.0
	AudioManager.cancel_audio(_get_sound_effect())
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


func _get_sound_effect() -> SoundEffectConfiguration.Type:
	match interaction_length:
		InteractionLength.SHORT:
			return SoundEffectConfiguration.Type.PROGRESS_INDICATOR_SHORT
		InteractionLength.MEDIUM:
			return SoundEffectConfiguration.Type.PROGRESS_INDICATOR_MEDIUM
		_:
			assert(false, "Interaction length does not have corresponding sound effect")
			return SoundEffectConfiguration.Type.PROGRESS_INDICATOR_MEDIUM
