class_name InteractArea

extends Area2D

signal interaction_complete

@export var completion_time := 2.5

var progress_indicator: ProgressIndicator
var _completion_progress := 0.0


func interact(delta: float) -> void:
	_completion_progress = min(_completion_progress + delta, completion_time)
	var completion_percentage = _completion_progress / completion_time
	progress_indicator.update_progress_bar(completion_percentage * 100.0)
	if _completion_progress == completion_time:
		interaction_complete.emit()
		monitoring = false


func reset_progress() -> void:
	_completion_progress = 0.0
	progress_indicator.update_progress_bar(0.0)


func _on_body_entered(_body) -> void:
	progress_indicator.fade_in()
	InteractionManager.register_area(self)


func _on_body_exited(_body) -> void:
	progress_indicator.fade_out()
	InteractionManager.unregister_area(self)
