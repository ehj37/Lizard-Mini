class_name PlayerGroundDetector

extends Area2D

var _movement_transform_areas: Array[MovementTransformArea] = []


func get_movement_vector(input_direction: Vector2) -> Vector2:
	if _movement_transform_areas.size() == 0:
		return input_direction

	# In theory there could be multiple different movement transform areas that
	# we'd care about here, but for now I'm just picking the first.
	var movement_transform_area := _movement_transform_areas[0]
	return movement_transform_area.apply_transform(input_direction)


func _on_area_entered(area: MovementTransformArea) -> void:
	_movement_transform_areas.append(area)


func _on_area_exited(area: MovementTransformArea) -> void:
	_movement_transform_areas.erase(area)
