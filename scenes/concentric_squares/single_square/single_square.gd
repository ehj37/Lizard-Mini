class_name SingleSquare

extends Node2D

signal finished

const COLOR = Color.YELLOW
const TWEEN_TIME = 3.5
const FADE_START = 1.5

@export var final_size := 200.0

@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	var style_box := StyleBoxFlat.new()
	style_box.set_border_width_all(1)
	style_box.bg_color = Color.TRANSPARENT
	style_box.border_color = COLOR
	panel_container.add_theme_stylebox_override("panel", style_box)


func expand() -> void:
	panel_container.size = Vector2(2, 2)
	panel_container.position = Vector2(-1, -1)
	panel_container.modulate.a = 1.0

	var size_tween := get_tree().create_tween()
	size_tween.tween_property(panel_container, "size", Vector2(final_size, final_size), TWEEN_TIME)

	var position_tween := get_tree().create_tween()
	position_tween.tween_property(
		panel_container, "position", Vector2(-final_size / 2.0, -final_size / 2.0), TWEEN_TIME
	)

	get_tree().create_timer(FADE_START).timeout.connect(
		func() -> void: get_tree().create_tween().tween_property(
			panel_container, "modulate:a", 0.0, TWEEN_TIME - FADE_START
		)
	)

	await get_tree().create_timer(TWEEN_TIME).timeout

	finished.emit()
