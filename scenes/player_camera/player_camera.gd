class_name PlayerCamera

extends Camera2D

const ORIENTATION_OFFSET := 30
const INITIAL_SHAKE_MAGNITUDE := 5.0
const SHAKE_DIMINISH_SPEED := 200.0

@export var player: Player

var _current_shake_magnitude := 5.0
var _registed_lock_areas: Array[CameraLockArea] = []


func register_lock_area(lock_area: CameraLockArea) -> void:
	_registed_lock_areas.append(lock_area)


func unregister_lock_area(lock_area: CameraLockArea) -> void:
	_registed_lock_areas.erase(lock_area)


func _ready() -> void:
	player.hurt.connect(_begin_shake)
	EventBus.shake_camera.connect(_begin_shake)

	position_smoothing_enabled = false
	_set_global_position_from_player()
	await get_tree().process_frame

	position_smoothing_enabled = true


func _process(delta: float) -> void:
	_set_global_position_from_player()

	if _current_shake_magnitude > 0:
		var shake_offset_x := randf_range(-_current_shake_magnitude, _current_shake_magnitude)
		var shake_offset_y := randf_range(-_current_shake_magnitude, _current_shake_magnitude)
		offset = Vector2(shake_offset_x, shake_offset_y)

		_current_shake_magnitude = max(_current_shake_magnitude - delta * SHAKE_DIMINISH_SPEED, 0)
	else:
		offset = Vector2.ZERO


func _set_global_position_from_player() -> void:
	var target_x := INF
	var target_y := INF

	for lock_area in _registed_lock_areas:
		if lock_area.lock_x:
			target_x = lock_area.global_position.x
		if lock_area.lock_y:
			target_y = lock_area.global_position.y

	var target_position_from_player := (
		player.global_position + player.orientation * ORIENTATION_OFFSET
	)
	if target_x == INF:
		target_x = target_position_from_player.x
	if target_y == INF:
		target_y = target_position_from_player.y

	global_position = Vector2(target_x, target_y)


func _begin_shake() -> void:
	_current_shake_magnitude = INITIAL_SHAKE_MAGNITUDE
