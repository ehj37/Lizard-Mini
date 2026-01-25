extends PlayerState

const HURT_MOVE_SPEED := 30.0
const ATTACK_QUEUE_WINDOW_START := 0.06

var _in_attack_queue_window := false
var _attack_queued := false

@onready var animation_map := {
	Vector2.UP.angle(): "hurt_up",
	Vector2.RIGHT.angle(): "hurt_right",
	Vector2.DOWN.angle(): "hurt_down",
	Vector2.LEFT.angle(): "hurt_right"
}


func update(_delta: float) -> void:
	var movement_dir := player.get_movement_direction()

	if movement_dir != Vector2.ZERO:
		player.sprite.flip_h = movement_dir.x < 0
		player.velocity = movement_dir * HURT_MOVE_SPEED
		player.orientation = movement_dir
	else:
		player.velocity = Vector2.ZERO

	if animation_player.is_playing():
		if _in_attack_queue_window && Input.is_action_just_pressed("attack"):
			_attack_queued = true

		return

	if _attack_queued:
		state_machine.transition_to("Attack")
		return

	if _attack_queued || Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	if movement_dir != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(data := {}) -> void:
	HitStopManager.hit_stop()

	AudioManager.play_effect_at(player.global_position, SoundEffectConfiguration.Type.PLAYER_OUCH)

	var damage_type: Hitbox.DamageType = data.get("type")
	if damage_type == Hitbox.DamageType.EXPLOSIVE:
		var damage_direction: Vector2 = data.get("direction")
		state_machine.transition_to("Fall", {"damage_direction": damage_direction})
		return

	player.velocity = Vector2.ZERO

	var animation := _get_animation(player.orientation)
	animation_player.play(animation)

	if player.orientation.x < 0:
		player.sprite.flip_h = true

	_in_attack_queue_window = false
	_attack_queued = false
	get_tree().create_timer(ATTACK_QUEUE_WINDOW_START).timeout.connect(_enter_attack_queue_window)


func exit() -> void:
	if animation_player.is_playing():
		animation_player.stop()


func _get_animation(dir: Vector2) -> String:
	return AnimationPicker.pick_animation(animation_map, dir.angle())


func _enter_attack_queue_window() -> void:
	if state_machine.current_state != self:
		return

	_in_attack_queue_window = true
