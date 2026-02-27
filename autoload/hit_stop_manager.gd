extends Node

const HIT_STOP_DURATION: float = 0.1


func hit_stop() -> void:
	get_tree().paused = true
	await get_tree().create_timer(HIT_STOP_DURATION).timeout

	get_tree().paused = false
