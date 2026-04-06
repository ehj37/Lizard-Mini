extends GolemState

const PRE_ATTACK_DURATION: float = 0.8
const SLAM_RADIUS: float = 25.0


func enter(_data: Dictionary = {}) -> void:
	golem.color_rect.color = Color.ORANGE
	golem.velocity = Vector2.ZERO

	get_tree().create_timer(PRE_ATTACK_DURATION).timeout.connect(_on_pre_attack_timer_timeout)


func _on_pre_attack_timer_timeout() -> void:
	if golem.global_position.distance_to(player.global_position) < SLAM_RADIUS:
		transition_to("Slam")
	else:
		transition_to("LungeSlam")
