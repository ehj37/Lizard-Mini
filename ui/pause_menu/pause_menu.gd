extends CanvasLayer

@onready var _center_container: CenterContainer = $CenterContainer
@onready var _main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var _settings: VBoxContainer = $CenterContainer/Settings
@onready var _main_volume_slider: HSlider = $CenterContainer/Settings/MainVolumeHSlider
@onready
var _sound_effects_volume_slider: HSlider = $CenterContainer/Settings/SoundEffectsVolumeHSlider
@onready var _music_volume_slider: HSlider = $CenterContainer/Settings/MusicVolumeHSlider
@onready var _resume_button: Button = $CenterContainer/MainButtons/ResumeButton
@onready var _animation_player: AnimationPlayer = $CenterContainer/AnimationPlayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			_pause()
		else:
			_resume()


func _ready() -> void:
	_center_container.modulate = Color.TRANSPARENT
	_main_buttons.visible = true
	_settings.visible = false
	_set_volume_slider_initial_values()


func _pause() -> void:
	_resume_button.disabled = false
	get_tree().paused = true
	_animation_player.play("blur")


func _resume() -> void:
	_resume_button.disabled = true
	_animation_player.play_backwards("blur")
	await _animation_player.animation_finished

	get_tree().paused = false


func _set_volume_slider_initial_values() -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	_main_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))

	var sound_effects_bus_index: int = AudioServer.get_bus_index("SoundEffects")
	_sound_effects_volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(sound_effects_bus_index)
	)

	var music_bus_index: int = AudioServer.get_bus_index("Music")
	_music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))


func _on_settings_button_pressed() -> void:
	_main_buttons.visible = false
	_settings.visible = true


func _on_main_volume_h_slider_value_changed(value: float) -> void:
	var master_bus_index: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(master_bus_index, value)


func _on_sound_effects_volume_h_slider_value_changed(value: float) -> void:
	var sound_effects_bus_index: int = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_volume_linear(sound_effects_bus_index, value)


func _on_music_volume_h_slider_value_changed(value: float) -> void:
	var music_bus_index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_bus_index, value)


func _on_back_button_pressed() -> void:
	_main_buttons.visible = true
	_settings.visible = false
