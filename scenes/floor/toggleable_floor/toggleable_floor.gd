@tool

class_name ToggleableFloor

extends Node2D

signal toggled_on
signal toggled_off

enum ToggleValue { ON, OFF }

@export var initial_value: ToggleValue = ToggleValue.OFF:
	set(new_value):
		initial_value = new_value
		if Engine.is_editor_hint():
			match new_value:
				ToggleValue.ON:
					modulate.a = 1.0
				ToggleValue.OFF:
					modulate.a = 0.2

			queue_redraw()

@export var toggle_box: ToggleBox

@onready var _current_toggle_value: ToggleValue = initial_value
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var _appear_sound_effect_config: SoundEffectConfig = preload("./sound_effects/appear.tres")
@onready
var _disappear_sound_effect_config: SoundEffectConfig = preload("./sound_effects/disappear.tres")


func toggle() -> void:
	match _current_toggle_value:
		ToggleValue.ON:
			toggle_off()
		ToggleValue.OFF:
			toggle_on()


func toggle_on() -> void:
	if _current_toggle_value == ToggleValue.ON:
		return

	_current_toggle_value = ToggleValue.ON

	visible = true
	_animation_player.play("appear")


func toggle_off() -> void:
	_current_toggle_value = ToggleValue.OFF
	_animation_player.play("disappear")


func _ready() -> void:
	if Engine.is_editor_hint():
		# Only want to do it when creating levels, not when editing the scene.
		var edited_scene_path: String = get_tree().edited_scene_root.scene_file_path
		if scene_file_path == edited_scene_path:
			return

		# For convenience, adding a toggle box child if one doesn't exist already
		if toggle_box == null:
			toggle_box = ToggleBox.new()
			toggle_box.name = "ToggleBox"
			add_child(toggle_box)
			toggle_box.owner = get_tree().edited_scene_root

		return

	modulate.a = 1.0

	toggle_box.toggled.connect(toggle)

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
