extends PlayerState

var _interact_area: InteractArea
var _interaction_complete: bool = false

@onready var animation_map: Dictionary = {
	Vector2.UP.angle(): "interact_up",
	Vector2.RIGHT.angle(): "interact_right",
	Vector2.DOWN.angle(): "interact_down",
	Vector2.LEFT.angle(): "interact_right"
}


func handle_input(event: InputEvent) -> void:
	if player._in_cinematic || event.is_action_released("interact"):
		var movement_direction: Vector2 = player.get_movement_direction()
		if movement_direction != Vector2.ZERO:
			transition_to("Run")
		else:
			transition_to("Idle")
		return


func update(delta: float) -> void:
	if _interaction_complete:
		var movement_direction: Vector2 = player.get_movement_direction()
		if movement_direction != Vector2.ZERO:
			transition_to("Run")
		else:
			transition_to("Idle")
		return

	_interact_area.interact(delta)


func enter(msg: Dictionary = {}) -> void:
	_interact_area = msg.get("interact_area")
	_interaction_complete = false
	_interact_area.interaction_complete.connect(func() -> void: _interaction_complete = true)
	player.velocity = Vector2.ZERO
	animation_player.play(_get_animation(player.orientation))


func exit() -> void:
	if !_interaction_complete:
		_interact_area.reset_progress()


func _get_animation(dir: Vector2) -> String:
	return AnimationPicker.pick_animation(animation_map, dir.angle())
