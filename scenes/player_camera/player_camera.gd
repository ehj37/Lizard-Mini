class_name PlayerCamera

extends Camera2D

const ORIENTATION_OFFSET: int = 30

@export var player: Player


func _process(_delta):
	global_position = player.global_position + player.orientation * ORIENTATION_OFFSET
