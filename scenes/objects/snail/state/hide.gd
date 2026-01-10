extends SnailState


func enter(_data := {}) -> void:
	snail.animation_player.play("hide")
	snail.hide_timer.start()


func _on_hide_timer_timeout():
	state_machine.transition_to("Emerge")
