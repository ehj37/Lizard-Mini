extends Node

const HIT_STOP_DURATION: float = 0.1


func hit_stop() -> void:
	# Wait until the start of the next physics frame to let the hurtboxes
	# respond to any overlapping hitboxes.
	# Without this, for a hitbox that's only active for a single physics frame,
	# it may be the case that the player's hurtbox detects a collision and
	# triggers a hitstop, pausing the tree, halting all physics processing,
	# and preventing another hurtbox from responding to that same hitbox.
	# E.g. if a golem's stomp might hurt the player and break a pot, without
	# this the player may get hurt while the pot stays intact.
	await get_tree().physics_frame

	get_tree().paused = true
	await get_tree().create_timer(HIT_STOP_DURATION).timeout

	get_tree().paused = false
