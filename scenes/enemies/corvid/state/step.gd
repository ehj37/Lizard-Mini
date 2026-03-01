class_name CorvidStepState

extends CorvidState

const STEP_DURATION: float = 0.3
const STEP_SPEED: float = 175.0
const STEP_ANGLE_MAX_OFFSET_MAGNITUDE: float = PI / 8

var _safe_velocity: Vector2
var _direction: Vector2
var _speed: float

var _angle_sign: int = -1

@onready var dust_cloud_packed_scene: PackedScene = preload(
	"res://scenes/enemies/corvid/step_dust_cloud/step_dust_cloud.tscn"
)


func physics_update(_delta: float) -> void:
	corvid.velocity = (_direction.rotated(_angle_sign * STEP_ANGLE_MAX_OFFSET_MAGNITUDE) * _speed)


func update(_delta: float) -> void:
	if !on_ground():
		state_machine.transition_to("Fall")


func enter(_data: Dictionary = {}) -> void:
	_speed = STEP_SPEED
	_direction = _safe_velocity.normalized()
	get_tree().create_tween().tween_property(self, "_speed", 0, STEP_DURATION)

	get_tree().create_timer(STEP_DURATION).timeout.connect(_on_step_timer_timeout)
	corvid.sprite.flip_h = _safe_velocity.x < 0
	# A previously played step animation may be still playing
	if corvid.animation_player.is_playing():
		corvid.animation_player.stop()
	corvid.animation_player.play("step")


func exit() -> void:
	_angle_sign *= -1


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	_safe_velocity = safe_velocity


func _on_step_timer_timeout() -> void:
	if state_machine.current_state != self:
		return

	var dust_cloud: Sprite2D = dust_cloud_packed_scene.instantiate()
	dust_cloud.global_position = corvid.global_position
	LevelManager.current_level.add_child(dust_cloud)

	state_machine.transition_to("Decide")
