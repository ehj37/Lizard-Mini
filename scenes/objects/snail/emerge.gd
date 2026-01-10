extends SnailState


func update(_delta: float) -> void:
	if !snail.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	snail.animation_player.play("emerge")
