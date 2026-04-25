class_name CinemaArea

extends Area2D

signal cinematic_started
signal cinematic_ended

@export var target_marker: Marker2D
@export var duration: float = 3.0


func _ready() -> void:
	if target_marker == null:
		push_error("Target marker undefined for CinemaArea at " + str(global_position))


func _pan_pause_unpan() -> void:
	set_deferred("monitoring", false)
	cinematic_started.emit()
	SignalBus.focus_camera.emit(target_marker.global_position)
	CinemaOverlay.apply()
	await get_tree().create_timer(duration).timeout

	SignalBus.unfocus_camera.emit()
	CinemaOverlay.remove()
	cinematic_ended.emit()


func _on_body_entered(player: Player) -> void:
	set_deferred("monitoring", false)

	_pan_pause_unpan()

	player.on_cinematic_started()
	cinematic_ended.connect(func() -> void: player.on_cinematic_ended())
