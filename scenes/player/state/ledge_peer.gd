extends PlayerState

var _most_recent_animation: String

@onready var animation_map := {
	Vector2.UP.angle(): "ledge_peer_up",
	Vector2.RIGHT.angle(): "ledge_peer_right",
	Vector2.DOWN.angle(): "ledge_peer_down",
	Vector2.LEFT.angle(): "ledge_peer_right"
}


func update(_delta: float) -> void:
	var movement_dir := player.get_movement_direction()

	if movement_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	player.orientation = movement_dir

	if Input.is_action_just_pressed("attack") && player.attack_cooldown_timer.is_stopped():
		state_machine.transition_to("Attack")
		return

	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return

	if Input.is_action_just_pressed("interact"):
		var interact_area := InteractionManager.get_interact_area()
		if interact_area:
			state_machine.transition_to("Interact", {"interact_area": interact_area})
			return

	if player.ground_detector.on_ledge(movement_dir):
		_update_sprite(movement_dir)
		return

	state_machine.transition_to("Run")


func enter(_data := {}) -> void:
	player.velocity = Vector2.ZERO
	_most_recent_animation = ""
	_update_sprite(player.get_movement_direction())


func _update_sprite(movement_direction: Vector2) -> void:
	player.sprite.flip_h = movement_direction.x < 0

	var animation := AnimationPicker.pick_animation(animation_map, movement_direction.angle())

	if _most_recent_animation != animation:
		animation_player.current_animation = animation
		_most_recent_animation = animation
