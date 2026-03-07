extends WipEnemyState


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		state_machine.transition_to("Alerted")
