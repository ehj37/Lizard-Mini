extends PlayerState

const INITIAL_SPEED: float = 120.0
const DECELERATION: float = 350.0

var _current_velocity: Vector2

@onready var _thud_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_fall_thud.tres"
)


func update(delta: float) -> void:
	_current_velocity = _current_velocity.move_toward(Vector2.ZERO, delta * DECELERATION)
	player.velocity = _current_velocity

	if !player.animation_player.is_playing():
		state_machine.transition_to("Rise")


func enter(data: Dictionary = {}) -> void:
	player.sprite_shadow.visible = false
	var damage_direction: Vector2 = data.get("damage_direction")
	# Set orientation to left or right because the player transitions to idle
	# right/idle left out of the Rise state.
	if damage_direction.x < 0:
		player.sprite.flip_h = true
		player.orientation = Vector2.LEFT
	else:
		player.sprite.flip_h = false
		player.orientation = Vector2.RIGHT

	_current_velocity = damage_direction * INITIAL_SPEED
	player.velocity = _current_velocity
	player.clear_burn()
	player.animation_player.play("fall_right")


func _thud() -> void:
	if player.ground_detector.on_floor():
		SoundEffectManager.play(_thud_sound_effect_config)
	else:
		state_machine.transition_to("FallPit")
