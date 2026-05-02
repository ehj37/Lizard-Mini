extends PlayerState

enum SwingDirection { U, UR, R, DR, D, DL, L, UL }

const INITIAL_LUNGE_SPEED: float = 80.0
const LUNGE_DECELERATION: float = 350.0
const MAX_COMBO_NUM: int = 2
const PITCH_MULTIPLIER_PER_ATTACK: float = 0.03
# TIMINGS
const POLYGON_ENABLE_TIME: float = 0.05
const POLYGON_DISABLE_TIME: float = 0.15
const COMBO_WINDOW_START: float = 0.225
# DIRECTIONS
const DIR_UR: Vector2 = Vector2(1, -1)
const DIR_DR: Vector2 = Vector2(1, 1)
const DIR_DL: Vector2 = Vector2(-1, 1)
const DIR_UL: Vector2 = Vector2(-1, -1)
const ATTACK_DIRECTIONS: Array[Vector2] = [
	Vector2.UP, DIR_UR, Vector2.RIGHT, DIR_DR, Vector2.DOWN, DIR_DL, Vector2.LEFT, DIR_UL
]
# ANIMATIONS
const ANIMATION_U_1: String = "swing_up_1"
const ANIMATION_U_2: String = "swing_up_2"
const ANIMATION_UR_1: String = "swing_up_right_1"
const ANIMATION_UR_2: String = "swing_up_right_2"
const ANIMATION_R_1: String = "swing_right_1"
const ANIMATION_R_2: String = "swing_right_2"
const ANIMATION_DR_1: String = "swing_down_right_1"
const ANIMATION_DR_2: String = "swing_down_right_2"
const ANIMATION_D_1: String = "swing_down_1"
const ANIMATION_D_2: String = "swing_down_2"

var _lunge_dir: Vector2
var _speed: float = 0.0
var _can_combo: bool = false
var _combo_num: int
var _sword_swing_sound_effect_identifier: int

@onready var animation_to_collision_polygon: Dictionary
@onready var combo_1_animation_map: Dictionary = {
	Vector2.UP.angle(): ANIMATION_U_1,
	Vector2(1, -1).angle(): ANIMATION_UR_1,
	Vector2.RIGHT.angle(): ANIMATION_R_1,
	Vector2(1, 1).angle(): ANIMATION_DR_1,
	Vector2.DOWN.angle(): ANIMATION_D_1,
	Vector2(-1, 1).angle(): ANIMATION_DR_1,
	Vector2.LEFT.angle(): ANIMATION_R_1,
	Vector2(-1, -1).angle(): ANIMATION_UR_1
}
@onready var combo_2_animation_map: Dictionary = {
	Vector2.UP.angle(): ANIMATION_U_2,
	Vector2(1, -1).angle(): ANIMATION_UR_2,
	Vector2.RIGHT.angle(): ANIMATION_R_2,
	Vector2(1, 1).angle(): ANIMATION_DR_2,
	Vector2.DOWN.angle(): ANIMATION_D_2,
	Vector2(-1, 1).angle(): ANIMATION_DR_2,
	Vector2.LEFT.angle(): ANIMATION_R_2,
	Vector2(-1, -1).angle(): ANIMATION_UR_2
}
@onready var _sword_swing_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/player/sound_effects/player_sword_swing.tres"
)


func handle_input(event: InputEvent) -> void:
	if player._in_cinematic:
		return

	if event.is_action_pressed("attack"):
		if _can_combo:
			transition_to("Attack", {"combo_num": _combo_num + 1})


func physics_update(delta: float) -> void:
	_speed = max(_speed - LUNGE_DECELERATION * delta, 0.0)
	if player.ground_detector.on_ledge(_lunge_dir):
		player.velocity = Vector2.ZERO
	else:
		player.velocity = player.orientation * _speed


func update(_delta: float) -> void:
	if animation_player.is_playing():
		return

	if player.get_movement_direction() == Vector2.ZERO:
		transition_to("Idle")
	else:
		transition_to("Run")


func enter(data: Dictionary = {}) -> void:
	var movement_direction: Vector2 = player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		_lunge_dir = movement_direction
		player.orientation = movement_direction
	else:
		_lunge_dir = player.orientation

	player.sword_bonk_detector.rotation = _lunge_dir.angle()

	_combo_num = data.get("combo_num", 0)
	var animation: String = _get_animation(_lunge_dir, _combo_num)
	animation_player.play(animation)
	_sword_swing_sound_effect_identifier = SoundEffectManager.play(_sword_swing_sound_effect_config)

	var collision_polygon: CollisionPolygon2D = animation_to_collision_polygon.get(animation)
	collision_polygon.disabled = false
	collision_polygon.visible = true

	if _lunge_dir.x < 0:
		player.sprite.flip_h = true
		player.hitbox_sword.scale.x = -1
	else:
		player.sprite.flip_h = false
		player.hitbox_sword.scale.x = 1

	_speed = INITIAL_LUNGE_SPEED
	if player.ground_detector.on_ledge(_lunge_dir):
		player.velocity = Vector2.ZERO
	else:
		player.velocity = _lunge_dir * INITIAL_LUNGE_SPEED
	player.hitbox_sword.orientation = player.orientation

	get_tree().create_timer(POLYGON_ENABLE_TIME, false).timeout.connect(_enable_sword)
	get_tree().create_timer(POLYGON_DISABLE_TIME, false).timeout.connect(_disable_sword)

	_can_combo = false
	get_tree().create_timer(COMBO_WINDOW_START, false).timeout.connect(_enter_combo_window)


func exit() -> void:
	if animation_player.is_playing():
		_disable_sword()
		SoundEffectManager.cancel(_sword_swing_sound_effect_identifier)
		animation_player.stop()

	# This is fine for combo attacks since they don't check the timer.
	player.attack_cooldown_timer.start()


func _ready() -> void:
	super()
	await owner.ready

	animation_to_collision_polygon = {
		ANIMATION_U_1: player.sword_polygon_u_1,
		ANIMATION_U_2: player.sword_polygon_u_2,
		ANIMATION_UR_1: player.sword_polygon_ur_1,
		ANIMATION_UR_2: player.sword_polygon_ur_2,
		ANIMATION_R_1: player.sword_polygon_r_1,
		ANIMATION_R_2: player.sword_polygon_r_2,
		ANIMATION_DR_1: player.sword_polygon_dr_1,
		ANIMATION_DR_2: player.sword_polygon_dr_2,
		ANIMATION_D_1: player.sword_polygon_d_1,
		ANIMATION_D_2: player.sword_polygon_d_2,
	}


func _get_animation(dir: Vector2, combo_num: int) -> String:
	# Happens on player spawn.
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT

	var angle: float = dir.angle()
	if combo_num == 1:
		return AnimationPicker.pick_animation(combo_2_animation_map, angle)

	# Right now, the first and third animations are the exact same.
	# Might makes sense to change it up down the line, but for now it looks
	# okay enough.
	return AnimationPicker.pick_animation(combo_1_animation_map, angle)


func _enable_sword() -> void:
	if state_machine.current_state != self:
		return

	if (
		player.sword_bonk_detector.has_overlapping_bodies()
		&& player.hitbox_sword.preview_hit_count() == 0
	):
		transition_to("SwordBonk", {"lunge_dir": _lunge_dir})
		return

	player.hitbox_sword.enable()


func _disable_sword() -> void:
	if state_machine.current_state != self:
		return

	player.hitbox_sword.disable()


func _enter_combo_window() -> void:
	if state_machine.current_state != self:
		return

	if _combo_num < MAX_COMBO_NUM:
		_can_combo = true
