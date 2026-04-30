class_name AppearingFloor

extends Node2D

signal toggled_on
signal toggled_off

enum ToggleValue { ON, OFF }

@export var initial_value: ToggleValue = ToggleValue.OFF

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var _appear_sound_effect_config: SoundEffectConfig = preload("./sound_effects/appear.tres")
@onready
var _disappear_sound_effect_config: SoundEffectConfig = preload("./sound_effects/disappear.tres")


func toggle_on() -> void:
	visible = true
	_animation_player.play("appear")


func toggle_off() -> void:
	_animation_player.play("disappear")


func _ready() -> void:
	match initial_value:
		ToggleValue.OFF:
			visible = false
			_collision_shape.disabled = true
		ToggleValue.ON:
			visible = true
			_collision_shape.disabled = false
			_animation_player.play("appear")
			_animation_player.seek(_animation_player.get_animation("appear").length)


func _emit_toggled_on() -> void:
	toggled_on.emit()


func _emit_toggled_off() -> void:
	toggled_off.emit()


func _play_appear_sound_effect() -> void:
	SoundEffectManager.play_at(_appear_sound_effect_config, global_position)


func _play_disappear_sound_effect() -> void:
	SoundEffectManager.play_at(_disappear_sound_effect_config, global_position)
