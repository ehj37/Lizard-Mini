extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.get_animation("poof").loop_mode = Animation.LOOP_NONE
	animation_player.play("poof")
	await animation_player.animation_finished

	queue_free()
