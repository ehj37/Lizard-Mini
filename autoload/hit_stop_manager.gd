extends Node

const HIT_STOP_DURATION := 0.15


func hit_stop() -> void:
	Engine.time_scale = 0
	# Fourth param of ignore_time_scale, the others are just defaults.
	await get_tree().create_timer(HIT_STOP_DURATION, true, false, true).timeout

	Engine.time_scale = 1.0
