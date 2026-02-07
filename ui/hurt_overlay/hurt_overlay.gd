extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_effect() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	animation_player.play("effect")
