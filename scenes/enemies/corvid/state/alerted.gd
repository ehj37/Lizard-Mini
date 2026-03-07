extends CorvidState


func update(_delta: float) -> void:
	if !corvid.animation_player.is_playing():
		state_machine.transition_to("Decide")


func enter(_data: Dictionary = {}) -> void:
	corvid.animation_player.play("alerted")


func _set_alerted() -> void:
	corvid.alerted = true
