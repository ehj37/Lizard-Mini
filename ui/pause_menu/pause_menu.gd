extends CanvasLayer

# TODO: Weird bug where pause randomly gets called without clicking escape.
# Should figure out why that's happening and remove this.
var _pause_pressed := false

@onready var color_rect: ColorRect = $Control/ColorRect
@onready var resume_button: Button = $Control/VBoxContainer/ResumeButton
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer


func pause() -> void:
	if !_pause_pressed:
		push_warning("Pause called for no conceivable reason (player didn't pause).")
		return

	resume_button.disabled = false
	get_tree().paused = true
	animation_player.play("blur")


func resume() -> void:
	_pause_pressed = false
	resume_button.disabled = true
	animation_player.play_backwards("blur")
	await animation_player.animation_finished

	get_tree().paused = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			_pause_pressed = true
			pause()
		else:
			resume()
