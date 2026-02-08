class_name ProgressIndicator

extends Node2D

const OSC_FREQUENCY := 2.0
const OSC_AMPLITUDE := 2.0

var _undulate_time := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sine_movement_container: Node2D = $SineMovementContainer
@onready var sprite: Sprite2D = $SineMovementContainer/Sprite2D
@onready var progress_bar: ProgressBar = $SineMovementContainer/ProgressBar


func update_progress_bar(amount: float) -> void:
	progress_bar.value = amount


func fade_in() -> void:
	animation_player.play("fade_in")


func fade_out() -> void:
	animation_player.play("fade_out")


func _ready() -> void:
	modulate = Color.TRANSPARENT


func _process(delta: float) -> void:
	if progress_bar.value == 0.0:
		_undulate_time += delta
		sine_movement_container.position.y = sin(_undulate_time * OSC_FREQUENCY) * OSC_AMPLITUDE
