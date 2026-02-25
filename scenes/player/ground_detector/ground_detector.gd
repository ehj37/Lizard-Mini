class_name PlayerGroundDetector

extends Node2D

enum Status { ON_SAFE_GROUND, ON_UNSAFE_GROUND, NOT_GROUNDED }

const NUM_PIT_DETECTORS: int = 16
const PIT_DETECTOR_RADIUS: float = 6.0

# Lights up the checked pit detector.
@export var debug_mode: bool = false

var _pit_detectors: Array[Area2D] = []

@onready var safe_floor_detector: Area2D = $SafeFloorDetector
@onready var unsafe_floor_detector: Area2D = $UnsafeFloorDetector


func _ready() -> void:
	var angle_between_pit_detectors: float = 2 * PI / NUM_PIT_DETECTORS

	for i: int in NUM_PIT_DETECTORS:
		var circle_shape: CircleShape2D = CircleShape2D.new()
		circle_shape.radius = 1.0
		var collision_shape: CollisionShape2D = CollisionShape2D.new()
		collision_shape.shape = circle_shape
		collision_shape.position = Vector2(PIT_DETECTOR_RADIUS, 0.0)
		var pit_detector: Area2D = Area2D.new()
		# Layer 2 is the ground layer
		pit_detector.set_collision_mask_value(2, true)
		pit_detector.add_child(collision_shape)
		pit_detector.rotate(i * angle_between_pit_detectors)
		_pit_detectors.append(pit_detector)
		add_child(pit_detector)


func on_floor() -> bool:
	return (
		safe_floor_detector.has_overlapping_bodies()
		|| unsafe_floor_detector.has_overlapping_bodies()
	)


func current_status() -> Status:
	var safe_overlapping_bodies: Array[Node2D] = safe_floor_detector.get_overlapping_bodies()
	var unsafe_overlapping_bodies: Array[Node2D] = unsafe_floor_detector.get_overlapping_bodies()

	if safe_overlapping_bodies.size() == 0 && unsafe_overlapping_bodies.size() == 0:
		return Status.NOT_GROUNDED

	if unsafe_overlapping_bodies.size() > 0:
		return Status.ON_UNSAFE_GROUND

	return Status.ON_SAFE_GROUND


func on_ledge(direction: Vector2) -> bool:
	if !on_floor():
		return false

	if direction == Vector2.ZERO:
		return false

	var direction_angle: float = direction.angle()

	var smallest_angle_difference: float = INF
	var closest_pit_detector: Area2D
	for pit_detector: Area2D in _pit_detectors:
		var difference: float = absf(angle_difference(pit_detector.rotation, direction_angle))
		if difference < smallest_angle_difference:
			closest_pit_detector = pit_detector
			smallest_angle_difference = difference

	if debug_mode:
		for pit_detector: Area2D in _pit_detectors:
			if pit_detector == closest_pit_detector:
				pit_detector.modulate = Color.RED
			else:
				pit_detector.modulate = Color.WHITE

	return !closest_pit_detector.has_overlapping_bodies()
