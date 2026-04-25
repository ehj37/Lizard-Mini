extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func apply() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	animation_player.play("hurt")
