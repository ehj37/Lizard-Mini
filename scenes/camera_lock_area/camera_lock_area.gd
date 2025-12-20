@tool

class_name CameraLockArea

extends Area2D

const COLOR_RECT_A := 0.05
const COLOR_X_ONLY := Color.RED
const COLOR_Y_ONLY := Color.GREEN
const COLOR_X_AND_Y := Color.PURPLE
const COLOR_NEITHER_X_OR_Y := Color.YELLOW

@export var player_camera: PlayerCamera

@export var lock_x := true:
	set(new_lock_x):
		lock_x = new_lock_x
		if Engine.is_editor_hint() && is_node_ready():
			_set_color()

@export var lock_y := true:
	set(new_lock_y):
		lock_y = new_lock_y
		if Engine.is_editor_hint() && is_node_ready():
			_set_color()

@onready var color_rect: ColorRect = $ColorRect


func _ready():
	if owner:
		assert(player_camera != null, "Must provide player camera export var")

	if Engine.is_editor_hint():
		var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
		var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
		color_rect.set_size(Vector2(viewport_width, viewport_height))
		color_rect.set_position(Vector2(-viewport_width / 2, -viewport_height / 2))

		_set_color()
	else:
		color_rect.visible = false


func _on_body_entered(_body) -> void:
	player_camera.register_lock_area(self)


func _on_body_exited(_body) -> void:
	player_camera.unregister_lock_area(self)


func _set_color() -> void:
	if lock_x && !lock_y:
		color_rect.color = COLOR_X_ONLY
	elif lock_y && !lock_x:
		color_rect.color = COLOR_Y_ONLY
	elif lock_x && lock_y:
		color_rect.color = COLOR_X_AND_Y
	else:
		color_rect.color = COLOR_NEITHER_X_OR_Y

	color_rect.color.a = COLOR_RECT_A
