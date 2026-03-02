extends CanvasLayer

@onready var fps_label: Label = $PanelContainer/VBoxContainer/FpsLabel
@onready var reset_button: Button = $PanelContainer/VBoxContainer/ResetButton
@onready var collision_shape_visibility_button: Button


func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second())

	if Input.is_action_just_pressed("debug"):
		visible = !visible
		reset_button.disabled = !visible
		collision_shape_visibility_button.disabled = !visible


func _ready() -> void:
	# Only reason I'm doing this here is that I'm fighting with GDFormat and
	# max line lengths.
	collision_shape_visibility_button = $PanelContainer/VBoxContainer/CollisionShapeVisibilityButton


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()


# https://github.com/godotengine/godot-proposals/issues/11790#issuecomment-2663234347
func _on_collision_shape_visibility_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.debug_collisions_hint = not tree.debug_collisions_hint

	# Traverse tree to call queue_redraw on instances of
	# CollisionShape2D and CollisionPolygon2D.
	var node_stack: Array[Node] = [tree.get_root()]
	while not node_stack.is_empty():
		var node: Node = node_stack.pop_back()
		if is_instance_valid(node):
			if node is CollisionShape2D or node is CollisionPolygon2D:
				(node as Node2D).queue_redraw()
			node_stack.append_array(node.get_children())
