extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func add_hurt() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	animation_player.play("hurt")


func add_cinema() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	animation_player.play("cinema")


func remove_cinema() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	animation_player.play("cinema", -1, -1)
