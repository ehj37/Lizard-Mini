extends GolemState


func update(_delta: float) -> void:
	if !golem.animation_player.is_playing():
		golem.alerted = true
		if can_attack():
			transition_to("DecideAttack")
		else:
			transition_to("Step")


func enter(_data: Dictionary = {}) -> void:
	(state_machine as GolemStateMachine).set_player()
	golem.animation_player.play("alerted")
