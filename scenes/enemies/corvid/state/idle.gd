extends CorvidState


func update(_delta: float) -> void:
	if !on_ground():
		state_machine.transition_to("Fall")
		return


func enter(_data: Dictionary = {}) -> void:
	corvid.animation_player.play("idle")
	var idle_animation_length: float = corvid.animation_player.get_animation("idle").length
	corvid.animation_player.advance(randf_range(0.0, idle_animation_length))
