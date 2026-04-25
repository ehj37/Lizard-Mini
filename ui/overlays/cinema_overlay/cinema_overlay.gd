extends CanvasLayer

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func apply() -> void:
	_animation_player.play("cinema")


func remove() -> void:
	_animation_player.play_backwards("cinema")
