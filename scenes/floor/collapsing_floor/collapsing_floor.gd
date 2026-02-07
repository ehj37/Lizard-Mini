class_name CollapsingFloor

extends StaticBody2D

const TIME_BEFORE_COLLAPSE = 0.65
const TIME_COLLAPSED = 0.8
const TIME_TO_REFORM = 0.3

var _can_collapse := true

@onready var detection_area: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _can_collapse:
		detection_area.set_deferred("monitoring", false)
		_collapse()


func _collapse() -> void:
	_can_collapse = false
	color_rect.color = Color.WHITE
	var initial_flash_tween := get_tree().create_tween()
	initial_flash_tween.tween_property(color_rect, "color", Color.BLUE, TIME_BEFORE_COLLAPSE)
	await get_tree().create_timer(TIME_BEFORE_COLLAPSE).timeout

	modulate.a = 0.5
	collision_shape.disabled = true
	await get_tree().create_timer(TIME_COLLAPSED).timeout

	_reform()


func _reform() -> void:
	var alpha_tween := get_tree().create_tween()
	alpha_tween.tween_property(self, "modulate:a", 1.0, TIME_TO_REFORM)
	await get_tree().create_timer(TIME_TO_REFORM).timeout

	_can_collapse = true
	detection_area.set_deferred("monitoring", true)
	collision_shape.disabled = false
