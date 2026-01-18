class_name MovementTransformArea

extends Area2D

# Order matters because of the angle calculation in get_transformation_matrix
enum Direction { RIGHT, DOWN_RIGHT, DOWN, DOWN_LEFT, LEFT, UP_LEFT, UP, UP_RIGHT }

# Eventually it may may sense to have this be configurable, but for stairs,
# I want to slow the player down in each direction, so this works nicely.
const SPEED_MULTIPLE := 0.8

@export var direction: Direction


func apply_transform(v: Vector2) -> Vector2:
	var transform_matrix = _get_transformation_matrix()
	var ab = transform_matrix[0]
	var cd = transform_matrix[1]
	var transformed_x = ab.x * v.x + ab.y * v.y
	var transformed_y = cd.x * v.x + cd.y * v.y
	return Vector2(transformed_x, transformed_y).normalized() * SPEED_MULTIPLE


# This transform matrix is somewhat scuffed. The lengths of the vectors you get
# after applying it are all over the place, so make sure to normalize after
# applying.
func _get_transformation_matrix() -> Array[Vector2]:
	var angle = direction * PI / 4
	var is_cardinal = is_zero_approx(fmod(angle, PI / 2))
	if is_cardinal:
		# Identity matrix
		return [Vector2.RIGHT, Vector2.DOWN]

	var angle_vector = Vector2.from_angle(angle)
	var transform_angle
	if angle_vector.x * angle_vector.y > 0:
		transform_angle = PI / 4
	else:
		transform_angle = -PI / 4

	return [Vector2(cos(transform_angle), 0), Vector2(sin(transform_angle), 1)]
