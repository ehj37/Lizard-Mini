class_name EnemyHealthBarPip

extends Control

@onready var color_rect: ColorRect = $ColorRect


func set_to_filled() -> void:
	color_rect.color.a = 1.0


func set_to_empty() -> void:
	color_rect.color.a = 0.4
