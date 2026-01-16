class_name ProgressIndicator

extends Node2D

const OSC_FREQUENCY := 2.0
const OSC_AMPLITUDE := 2.0

var _undulate_time := 0.0
var _alpha_tween: Tween

@onready var sine_movement_container: Node2D = $SineMovementContainer
@onready var sprite: Sprite2D = $SineMovementContainer/Sprite2D
@onready var progress_bar: ProgressBar = $SineMovementContainer/ProgressBar


func update_progress_bar(amount: float) -> void:
	progress_bar.value = amount


func fade_in() -> void:
	_kill_alpha_tween()
	_alpha_tween = get_tree().create_tween()
	_alpha_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	_alpha_tween.set_trans(Tween.TRANS_EXPO)


func fade_out() -> void:
	_kill_alpha_tween()
	_alpha_tween = get_tree().create_tween()
	_alpha_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	_alpha_tween.set_trans(Tween.TRANS_EXPO)


func _ready() -> void:
	modulate = Color.TRANSPARENT


func _process(delta: float) -> void:
	if progress_bar.value == 0.0:
		_undulate_time += delta
		sine_movement_container.position.y = sin(_undulate_time * OSC_FREQUENCY) * OSC_AMPLITUDE


func _kill_alpha_tween() -> void:
	if is_instance_valid(_alpha_tween):
		_alpha_tween.kill()
