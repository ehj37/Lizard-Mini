extends PlayerState


func update(_delta: float) -> void:
	if !animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	animation_player.play("rise_right")


func exit() -> void:
	player.sprite_shadow.visible = true
