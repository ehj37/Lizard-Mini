extends PlayerState

var _interact_area: InteractArea
var _interaction_complete := false


func update(delta: float) -> void:
	if !Input.is_action_pressed("interact") || _interaction_complete:
		var movement_direction = player.get_movement_direction()
		if movement_direction != Vector2.ZERO:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
		return

	_interact_area.interact(delta)


func enter(msg := {}) -> void:
	_interact_area = msg.get("interact_area")
	_interaction_complete = false
	_interact_area.interaction_complete.connect(func(): _interaction_complete = true)
	player.velocity = Vector2.ZERO


func exit() -> void:
	if !_interaction_complete:
		_interact_area.reset_progress()
