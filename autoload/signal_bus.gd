extends Node

@warning_ignore("unused_signal")
signal shake_camera(shake_magnitude: CameraShakeMagnitude, direction: Vector2)
@warning_ignore("unused_signal")
signal focus_camera(target: Vector2)
@warning_ignore("unused_signal")
signal unfocus_camera

enum CameraShakeMagnitude { SMALL, MEDIUM, LARGE }
