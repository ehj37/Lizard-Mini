class_name PlayerCamera

extends Camera2D

const ORIENTATION_OFFSET := 30
const INITIAL_SHAKE_MAGNITUDE := 5.0
const SHAKE_DIMINISH_SPEED := 200.0

@export var player: Player

var _current_shake_magnitude := 5.0


func _ready() -> void:
	player.hurt.connect(_begin_shake)


func _process(delta: float) -> void:
	global_position = player.global_position + player.orientation * ORIENTATION_OFFSET

	if _current_shake_magnitude > 0:
		var shake_offset_x = randf_range(-_current_shake_magnitude, _current_shake_magnitude)
		var shake_offset_y = randf_range(-_current_shake_magnitude, _current_shake_magnitude)
		offset = Vector2(shake_offset_x, shake_offset_y)

		_current_shake_magnitude = max(_current_shake_magnitude - delta * SHAKE_DIMINISH_SPEED, 0)
	else:
		offset = Vector2.ZERO


func _begin_shake() -> void:
	_current_shake_magnitude = INITIAL_SHAKE_MAGNITUDE
