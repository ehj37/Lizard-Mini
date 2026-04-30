class_name CollapsingFloor

extends StaticBody2D

var _is_player_on: bool = false

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready
var _collapse_sound_effect_config: SoundEffectConfig = preload("./sound_effects/collapse.tres")
@onready var _reform_sound_effect_config: SoundEffectConfig = preload("./sound_effects/reform.tres")


func _ready() -> void:
	_animation_player.play("reform")
	_animation_player.seek(_animation_player.get_animation("reform").length)


func _collapse_and_reform() -> void:
	_animation_player.play("collapse")
	SoundEffectManager.play_at(_collapse_sound_effect_config, global_position)
	await _animation_player.animation_finished

	_animation_player.play("reform")
	SoundEffectManager.play_at(_reform_sound_effect_config, global_position)
	await _animation_player.animation_finished

	if _is_player_on:
		_collapse_and_reform()


func _on_player_detection_area_body_entered(_player: Player) -> void:
	_is_player_on = true
	if !_animation_player.is_playing():
		_collapse_and_reform()


func _on_player_detection_area_body_exited(_player: Player) -> void:
	_is_player_on = false
