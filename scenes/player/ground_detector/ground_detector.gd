class_name PlayerGroundDetector

extends Node2D

const NUM_PIT_DETECTORS := 16
const PIT_DETECTOR_RADIUS := 6.0

# Lights up the checked pit detector.
@export var debug_mode := false

var _pit_detectors: Array[Area2D] = []

@onready var floor_detector: Area2D = $FloorDetector


func _ready() -> void:
	var angle_between_pit_detectors := 2 * PI / NUM_PIT_DETECTORS

	for i in NUM_PIT_DETECTORS:
		var circle_shape := CircleShape2D.new()
		circle_shape.radius = 1.0
		var collision_shape := CollisionShape2D.new()
		collision_shape.shape = circle_shape
		collision_shape.position = Vector2(PIT_DETECTOR_RADIUS, 0.0)
		var pit_detector := Area2D.new()
		# Layer 2 is the ground layer
		pit_detector.set_collision_mask_value(2, true)
		pit_detector.add_child(collision_shape)
		pit_detector.rotate(i * angle_between_pit_detectors)
		_pit_detectors.append(pit_detector)
		add_child(pit_detector)


func on_floor() -> bool:
	return floor_detector.has_overlapping_bodies()


func on_ledge(direction: Vector2) -> bool:
	# If this is the case, the player isn't on a ledge, they're mid-air!
	if !floor_detector.has_overlapping_bodies():
		return false

	if direction == Vector2.ZERO:
		return false

	var direction_angle := direction.angle()

	var smallest_angle_difference := INF
	var closest_pit_detector: Area2D
	for pit_detector in _pit_detectors:
		var difference := absf(angle_difference(pit_detector.rotation, direction_angle))
		if difference < smallest_angle_difference:
			closest_pit_detector = pit_detector
			smallest_angle_difference = difference

	if debug_mode:
		for pit_detector in _pit_detectors:
			if pit_detector == closest_pit_detector:
				pit_detector.modulate = Color.RED
			else:
				pit_detector.modulate = Color.WHITE

	return !closest_pit_detector.has_overlapping_bodies()
