extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	fade_in()


func fade_in() -> void:
	animation_player.play("fade_in")


func fade_out() -> void:
	animation_player.play("fade_out")
