class_name Player

extends CharacterBody2D

signal hurt

const MOVEMENT_INPUTS: Array[String] = ["move_up", "move_right", "move_down", "move_left"]
const VERTICAL_MOVEMENT_INPUTS: Array[String] = ["move_up", "move_down"]
const HORIZONTAL_MOVEMENT_INPUTS: Array[String] = ["move_right", "move_left"]
const MOVEMENT_INPUT_TO_DIR := {
	"move_up": Vector2.UP,
	"move_right": Vector2.RIGHT,
	"move_down": Vector2.DOWN,
	"move_left": Vector2.LEFT
}

var orientation: Vector2 = Vector2.ZERO
var _pressed_movement_inputs: Array[String] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_feet: Hurtbox = $HurtboxFeet
@onready var hitbox_sword: HitboxSword = $HitboxSword
@onready var hitbox_feet: Hitbox = $HitboxFeet
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
# Sword collision polygons
@onready var sword_polygon_u_1: CollisionPolygon2D = $HitboxSword/CollisionPolygonUp1
@onready var sword_polygon_u_2: CollisionPolygon2D = $HitboxSword/CollisionPolygonUp2
@onready var sword_polygon_ur_1: CollisionPolygon2D = $HitboxSword/CollisionPolygonUpRight1
@onready var sword_polygon_ur_2: CollisionPolygon2D = $HitboxSword/CollisionPolygonUpRight2
@onready var sword_polygon_r_1: CollisionPolygon2D = $HitboxSword/CollisionPolygonRight1
@onready var sword_polygon_r_2: CollisionPolygon2D = $HitboxSword/CollisionPolygonRight2
@onready var sword_polygon_dr_1: CollisionPolygon2D = $HitboxSword/CollisionPolygonDownRight1
@onready var sword_polygon_dr_2: CollisionPolygon2D = $HitboxSword/CollisionPolygonDownRight2
@onready var sword_polygon_d_1: CollisionPolygon2D = $HitboxSword/CollisionPolygonDown1
@onready var sword_polygon_d_2: CollisionPolygon2D = $HitboxSword/CollisionPolygonDown2


func _physics_process(_delta):
	move_and_slide()


func _process(_delta):
	for movement_input in MOVEMENT_INPUTS:
		if Input.is_action_pressed(movement_input):
			if !_pressed_movement_inputs.has(movement_input):
				_pressed_movement_inputs.append(movement_input)
		else:
			_pressed_movement_inputs.erase(movement_input)


func take_damage(amount: int, type: Hitbox.DamageType, direction: Vector2) -> void:
	hurt.emit()
	shader_animation_player.play("hurt_flash")

	# The player can get hurt in the fall and rise states, but they don't get
	# transitioned to the hurt state from it.
	# They just flash magenta, and continue with falling/getting up.
	var current_state_name = state_machine.current_state.name
	if current_state_name == "Fall" || current_state_name == "Rise":
		return

	state_machine.transition_to("Hurt", {"amount": amount, "type": type, "direction": direction})


func get_movement_direction() -> Vector2:
	var movement_vector = Vector2.ZERO
	var vertical_movement_input_i = _pressed_movement_inputs.rfind_custom(
		func(movement_input): return VERTICAL_MOVEMENT_INPUTS.has(movement_input)
	)
	var horizontal_movement_input_i = _pressed_movement_inputs.rfind_custom(
		func(movement_input): return HORIZONTAL_MOVEMENT_INPUTS.has(movement_input)
	)
	if vertical_movement_input_i != -1:
		var vertical_movement_input = _pressed_movement_inputs[vertical_movement_input_i]
		movement_vector += MOVEMENT_INPUT_TO_DIR[vertical_movement_input]

	if horizontal_movement_input_i != -1:
		var horizontal_movement_input = _pressed_movement_inputs[horizontal_movement_input_i]
		movement_vector += MOVEMENT_INPUT_TO_DIR[horizontal_movement_input]

	return movement_vector.normalized()


func _on_hitbox_sword_blood_drawn():
	pass
