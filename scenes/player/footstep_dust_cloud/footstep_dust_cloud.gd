extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("poof")
	animation_player.animation_finished.connect(func(_anim_name: String) -> void: queue_free())
