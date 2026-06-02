extends PlayerState

const POST_FALL_SPRITE_FLICKER_DURATION: float = 1.0

@onready var _fall_pit_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_fall_pit.tres"
)


func update(_delta: float) -> void:
	if player.animation_player.is_playing():
		return

	player.global_position = player.last_safe_global_position

	if player.ground_detector.current_status() == PlayerGroundDetector.Status.ON_SAFE_GROUND:
		state_machine.transition_to("Idle")


func enter(_data: Dictionary = {}) -> void:
	player.velocity = Vector2.ZERO

	# Setting state that'll be restored on exit
	player.hurtbox.disable()
	player.hurtbox_feet.disable()
	_toggle_collision(false)

	player.sprite_shadow.visible = false

	SoundEffectManager.play(_fall_pit_sound_effect_config)
	animation_player.play("fall_pit")
	player.sprite.apply_fall_offset_and_z_index()

	player.remove_burn()


func exit() -> void:
	# Restoring state that was changed on enter
	player.hurtbox.enable()
	player.hurtbox_feet.enable()
	_toggle_collision(true)
	player.sprite_shadow.visible = true
	player.sprite.reset_fall_offset_and_z_index()
	# TODO: Damage immunity post fall
	player.sprite.flicker(POST_FALL_SPRITE_FLICKER_DURATION)


# We do this instead of changing the disabled value for the player collision
# shape so the player is still detectable via a camera lock area (via the
# "CameraLockAreaDetectable" layer).
# If we disabled the collision shape on fall while in a camera lock zone,
# the camera lock would break, and potentially re-snap if the player spawned
# back into the same lock zone.
func _toggle_collision(on: bool) -> void:
	player.set_collision_layer_value(8, on)
