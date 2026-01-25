class_name AnimationPicker

extends Node


# Picks an animation given a mapping of angles to animation names and an angle
# to choose an animation for.
# An animation is picked by finding the closest animation angle to the provided
# angle. In the event of ties, angles with greater horizontal components win.
# E.g. if the player runs up and to the right (45 deg angle), the horizontal
# animation is chosen
static func pick_animation(animation_map: Dictionary, angle: float) -> String:
	var animation: String
	var closest_angle := INF
	var closest_angle_diff_magnitude := INF
	for animation_angle: float in animation_map:
		var angle_diff_magnitude := absf(angle_difference(animation_angle, angle))
		if is_equal_approx(angle_diff_magnitude, closest_angle_diff_magnitude):
			if (
				absf(Vector2.from_angle(animation_angle).x)
				> absf(Vector2.from_angle(closest_angle).x)
			):
				animation = animation_map.get(animation_angle)
				closest_angle = animation_angle
		elif angle_diff_magnitude < closest_angle_diff_magnitude:
			animation = animation_map.get(animation_angle)
			closest_angle = animation_angle
			closest_angle_diff_magnitude = angle_diff_magnitude

	assert(animation != "", "Animation picker could not choose an animation.")
	return animation
