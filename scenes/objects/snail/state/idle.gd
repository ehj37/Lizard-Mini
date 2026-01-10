extends SnailState


func update(_delta: float) -> void:
	if !snail.animation_player.is_playing():
		state_machine.transition_to("Move")


func enter(_data := {}) -> void:
	snail.animation_player.play("idle")
