class_name SkewArea

extends Area2D

enum SkewType { CLOCKWISE, COUNTERCLOCKWISE }

const CLOCKWISE_ANGLE: float = PI / 4
const COUNTERCLOCKWISE_ANGLE: float = -PI / 4

@export var skew_type: SkewType


# Result is normalized
func apply_skew(v: Vector2) -> Vector2:
	var transform_matrix: Array[Vector2] = _get_transformation_matrix()
	var ab: Vector2 = transform_matrix[0]
	var cd: Vector2 = transform_matrix[1]
	var transformed_x: float = ab.x * v.x + ab.y * v.y
	var transformed_y: float = cd.x * v.x + cd.y * v.y
	return Vector2(transformed_x, transformed_y).normalized()


# A normal vertical skew matrix. Length not necessarily preserved.
func _get_transformation_matrix() -> Array[Vector2]:
	var angle: float
	match skew_type:
		SkewType.CLOCKWISE:
			angle = CLOCKWISE_ANGLE
		SkewType.COUNTERCLOCKWISE:
			angle = COUNTERCLOCKWISE_ANGLE

	return [Vector2(1, 0), Vector2(tan(angle), 1)]
