extends PlayerState

enum SwingDirection {}

const INITIAL_LUNGE_SPEED := 80.0
const LUNGE_DECELERATION := 350.0
const MAX_COMBO_NUM := 2
const PITCH_MULTIPLIER_PER_ATTACK := 0.03
# TIMINGS
const POLYGON_ENABLE_TIME := 0.025
const POLYGON_DISABLE_TIME := 0.15
const COMBO_WINDOW_START := 0.225
# DIRECTIONS
const DIR_UR := Vector2(1, -1)
const DIR_DR := Vector2(1, 1)
const DIR_DL := Vector2(-1, 1)
const DIR_UL := Vector2(-1, -1)
const ATTACK_DIRECTIONS: Array[Vector2] = [
	Vector2.UP, DIR_UR, Vector2.RIGHT, DIR_DR, Vector2.DOWN, DIR_DL, Vector2.LEFT, DIR_UL
]
# ANIMATIONS
const ANIMATION_U_1 := "swing_up_1"
const ANIMATION_U_2 := "swing_up_2"
const ANIMATION_UR_1 := "swing_up_right_1"
const ANIMATION_UR_2 := "swing_up_right_2"
const ANIMATION_R_1 := "swing_right_1"
const ANIMATION_R_2 := "swing_right_2"
const ANIMATION_DR_1 := "swing_down_right_1"
const ANIMATION_DR_2 := "swing_down_right_2"
const ANIMATION_D_1 := "swing_down_1"
const ANIMATION_D_2 := "swing_down_2"

var _lunge_dir: Vector2
var _speed := 0.0
var _can_combo := false
var _combo_num: int

@onready var animation_to_collision_polygon: Dictionary
@onready var combo_1_animation_map := {
	Vector2.UP.angle(): ANIMATION_U_1,
	Vector2(1, -1).angle(): ANIMATION_UR_1,
	Vector2.RIGHT.angle(): ANIMATION_R_1,
	Vector2(1, 1).angle(): ANIMATION_DR_1,
	Vector2.DOWN.angle(): ANIMATION_D_1,
	Vector2(-1, 1).angle(): ANIMATION_DR_1,
	Vector2.LEFT.angle(): ANIMATION_R_1,
	Vector2(-1, -1).angle(): ANIMATION_UR_1
}
@onready var combo_2_animation_map := {
	Vector2.UP.angle(): ANIMATION_U_2,
	Vector2(1, -1).angle(): ANIMATION_UR_2,
	Vector2.RIGHT.angle(): ANIMATION_R_2,
	Vector2(1, 1).angle(): ANIMATION_DR_2,
	Vector2.DOWN.angle(): ANIMATION_D_2,
	Vector2(-1, 1).angle(): ANIMATION_DR_2,
	Vector2.LEFT.angle(): ANIMATION_R_2,
	Vector2(-1, -1).angle(): ANIMATION_UR_2
}


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


func physics_update(delta: float) -> void:
	_speed = max(_speed - LUNGE_DECELERATION * delta, 0.0)
	if player.ground_detector.on_ledge(_lunge_dir):
		player.velocity = Vector2.ZERO
	else:
		player.velocity = player.orientation * _speed


func update(_delta: float) -> void:
	if _can_combo:
		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack", {"combo_num": _combo_num + 1})

	if animation_player.is_playing():
		return

	if player.get_movement_direction() != Vector2.ZERO:
		state_machine.transition_to("Run")
		return

	state_machine.transition_to("Idle")


func enter(data := {}) -> void:
	player.hitbox_sword.disabled = false

	var movement_direction := player.get_movement_direction()
	if movement_direction != Vector2.ZERO:
		_lunge_dir = movement_direction
		player.orientation = movement_direction
	else:
		_lunge_dir = player.orientation

	_combo_num = data.get("combo_num", 0)
	var animation := _get_animation(_lunge_dir, _combo_num)
	var pitch_multiplier := 1.0 + _combo_num * PITCH_MULTIPLIER_PER_ATTACK
	animation_player.play(animation)
	AudioManager.play_effect_at(
		player.global_position, SoundEffectConfiguration.Type.PLAYER_SWORD_SWING, pitch_multiplier
	)

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

	get_tree().create_timer(POLYGON_ENABLE_TIME).timeout.connect(_enable_sword)
	get_tree().create_timer(POLYGON_DISABLE_TIME).timeout.connect(_disable_sword)

	_can_combo = false
	get_tree().create_timer(COMBO_WINDOW_START).timeout.connect(_enter_combo_window)


func exit() -> void:
	if animation_player.is_playing():
		_disable_sword()
		AudioManager.cancel_audio(SoundEffectConfiguration.Type.PLAYER_SWORD_SWING)
		animation_player.stop()

	# This is fine for combo attacks since they don't check the timer.
	player.attack_cooldown_timer.start()


func _get_animation(dir: Vector2, combo_num: int) -> String:
	# Happens on player spawn.
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT

	var angle := dir.angle()
	if combo_num == 2:
		return AnimationPicker.pick_animation(combo_2_animation_map, angle)

	# Right now, the first and third animations are the exact same.
	# Might makes sense to change it up down the line, but for now it looks
	# okay enough.
	return AnimationPicker.pick_animation(combo_1_animation_map, angle)


func _enable_sword() -> void:
	if state_machine.current_state != self:
		return

	player.hitbox_sword.enable()
	var collision_polygon: CollisionPolygon2D = animation_to_collision_polygon.get(
		animation_player.current_animation
	)

	collision_polygon.disabled = false
	collision_polygon.visible = true


func _disable_sword() -> void:
	if state_machine.current_state != self:
		return

	player.hitbox_sword.disable()
	var collision_polygon: CollisionPolygon2D = animation_to_collision_polygon.get(
		animation_player.current_animation
	)
	collision_polygon.disabled = true
	collision_polygon.visible = false


func _enter_combo_window() -> void:
	if state_machine.current_state != self:
		return

	if _combo_num < MAX_COMBO_NUM:
		_can_combo = true
