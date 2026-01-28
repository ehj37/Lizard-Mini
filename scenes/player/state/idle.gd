extends PlayerState

@onready var impatient_timer: Timer = $ImpatientTimer
@onready var sit_timer: Timer = $SitTimer
@onready var animation_map := {
	Vector2.UP.angle(): "idle_up",
	Vector2.RIGHT.angle(): "idle_right",
	Vector2.DOWN.angle(): "idle_down",
	Vector2.LEFT.angle(): "idle_right"
}


func update(_delta: float) -> void:
	if !player.ground_detector.on_floor():
		state_machine.transition_to("FallPit")
		return

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

	var movement_direction := player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		state_machine.transition_to("Run")


func enter(data := {}) -> void:
	player.velocity = Vector2.ZERO

	if player.ground_detector.on_floor():
		player.last_safe_global_position = player.global_position

	var animation := _get_animation(player.orientation)
	animation_player.play(animation)

	player.sprite.flip_h = player.orientation.x < 0

	var impatient: bool = data.get("impatient", false)
	if !impatient:
		impatient_timer.start()
	else:
		sit_timer.start()


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()

	impatient_timer.stop()
	sit_timer.stop()


func _get_animation(dir: Vector2) -> String:
	return AnimationPicker.pick_animation(animation_map, dir.angle())


func _play_blink_sound_effect() -> void:
	AudioManager.play_effect_at(player.global_position, SoundEffectConfiguration.Type.PLAYER_BLINK)


func _on_impatient_timer_timeout() -> void:
	state_machine.transition_to("Impatient")


func _on_sit_timer_timeout() -> void:
	state_machine.transition_to("Sit")
