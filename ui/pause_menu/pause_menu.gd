extends CanvasLayer

@onready var color_rect: ColorRect = $Control/ColorRect
@onready var resume_button: Button = $Control/VBoxContainer/ResumeButton
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func pause() -> void:
	resume_button.disabled = false
	get_tree().paused = true
	animation_player.play("blur")


func resume() -> void:
	resume_button.disabled = true
	animation_player.play_backwards("blur")
	await animation_player.animation_finished

	get_tree().paused = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
		else:
			resume()
