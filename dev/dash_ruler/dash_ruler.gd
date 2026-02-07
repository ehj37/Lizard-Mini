@tool

extends Node2D

@onready var min_dash_color_rect: ColorRect = $MinDashColorRect
@onready var max_dash_color_rect: ColorRect = $MaxDashColorRect


func _ready() -> void:
	if !Engine.is_editor_hint():
		visible = false
		push_warning("Dash ruler left in level!")

	min_dash_color_rect.size.x = PlayerDashState.DASH_SPEED * PlayerDashState.MOVEMENT_DURATION
	max_dash_color_rect.size.x = (
		min_dash_color_rect.size.x
		+ PlayerDashState.DASH_SPEED * PlayerDashState.MOVEMENT_EXTENSION_DURATION
	)
