class_name CollapsingFloor

extends StaticBody2D

var _is_player_on: bool = false

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_animation_player.play("reform")
	_animation_player.seek(_animation_player.get_animation("reform").length)


func _collapse_and_reform() -> void:
	_animation_player.play("collapse")
	await _animation_player.animation_finished

	_animation_player.play("reform")
	await _animation_player.animation_finished

	if _is_player_on:
		_collapse_and_reform()


func _on_player_detection_area_body_entered(_player: Player) -> void:
	_is_player_on = true
	if !_animation_player.is_playing():
		_collapse_and_reform()


func _on_player_detection_area_body_exited(_player: Player) -> void:
	_is_player_on = false
