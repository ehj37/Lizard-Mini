extends CorvidState

const ATTACK_LUNGE_SPEED: float = 375.0
const ATTACK_LUNGE_DURATION: float = 0.2
const HITBOX_ENABLE_TIME: float = 0.1
const DECELERATION_START: float = 0.1

var _direction: Vector2
var _deceleration_tween: Tween

@onready var dust_cloud_packed_scene: PackedScene = preload(
	"res://scenes/enemies/corvid/lunge_dust_cloud/lunge_dust_cloud.tscn"
)
@onready var _attack_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/enemies/corvid/sound_effects/corvid_attack.tres"
)


func physics_update(_delta: float) -> void:
	corvid.velocity = _direction * ATTACK_LUNGE_SPEED


# Hitbox gets enabled via animation
func enter(data: Dictionary = {}) -> void:
	corvid.animation_player.play("attack")

	SoundEffectManager.play_at(_attack_sound_effect_config, corvid.global_position)

	corvid.set_collision_mask_value(8, false)

	get_tree().create_timer(DECELERATION_START, false).timeout.connect(
		_on_deceleration_start_timer_timeout
	)

	var target: Vector2 = data.get("target")
	_direction = corvid.global_position.direction_to(target)
	if _direction.x < 0:
		corvid.hitbox.position.x = -abs(corvid.hitbox.position.x)
	else:
		corvid.hitbox.position.x = abs(corvid.hitbox.position.x)

	get_tree().create_timer(ATTACK_LUNGE_DURATION, false).timeout.connect(_on_lunge_timer_timeout)


func exit() -> void:
	corvid.set_collision_mask_value(8, true)
	corvid.hitbox.disable()

	if is_instance_valid(_deceleration_tween):
		_deceleration_tween.stop()


func _on_deceleration_start_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var deceleration_time: float = ATTACK_LUNGE_DURATION - DECELERATION_START
	_deceleration_tween = get_tree().create_tween()
	_deceleration_tween.tween_property(corvid, "velocity", Vector2.ZERO, deceleration_time)


func _on_lunge_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	# Don't spawn a dust cloud mid-air
	if corvid.ground_detector.has_overlapping_bodies():
		var dust_cloud: Sprite2D = dust_cloud_packed_scene.instantiate()
		dust_cloud.global_position = corvid.global_position
		LevelManager.current_level.add_child(dust_cloud)

	state_machine.transition_to("PostAttack")
