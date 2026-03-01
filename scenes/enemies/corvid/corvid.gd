@tool

class_name Corvid

extends Enemy

enum InitialOrientation { RIGHT, LEFT }

const MAX_HEALTH: int = 3

@export var log_state_transitions: bool = false
@export var initial_orientation: InitialOrientation = InitialOrientation.RIGHT:
	set(new_value):
		var p_d: CorvidPlayerDetector = $PlayerDetector
		var spr: Sprite2D = $Sprite2D
		match new_value:
			InitialOrientation.RIGHT:
				spr.flip_h = false
				p_d.orientation = CorvidPlayerDetector.DetectorOrientation.RIGHT
			InitialOrientation.LEFT:
				spr.flip_h = true
				p_d.orientation = CorvidPlayerDetector.DetectorOrientation.LEFT
		initial_orientation = new_value

var _player: Player
var _health: int = MAX_HEALTH

@onready var state_machine: CorvidStateMachine = $CorvidStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround
@onready var hitbox: Hitbox = $Hitbox
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ground_detector: Area2D = $GroundDetector
@onready var health_label: Label = $HealthLabel
# These get freed on alert
@onready var enemy_alert_chainer: EnemyAlertChainer = $EnemyAlertChainer
@onready var player_detector: CorvidPlayerDetector = $PlayerDetector


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	if !alerted:
		alert()

	# To consider: burn?
	# Probably not the best way of doing this since (from the other enemy's perspective)
	# the attack will have landed (i.e. take_damage was called).
	var relevant_damage_types: Array[Hitbox.DamageType] = _types.filter(
		func(type: Hitbox.DamageType) -> bool: return type != Hitbox.DamageType.ENEMY
	)
	if relevant_damage_types.is_empty():
		return

	_health -= 1
	health_label.text = str(_health)
	if _health > 0:
		shader_animation_player.play("hurt_flash")
	else:
		shader_animation_player.play("death_flash")
		death.emit()
		HitStopManager.hit_stop()
		state_machine.transition_to("Death")


func alert() -> void:
	super()

	state_machine.set_player()

	if is_instance_valid(player_detector):
		player_detector.queue_free()

	if is_instance_valid(enemy_alert_chainer):
		enemy_alert_chainer.queue_free()

	if state_machine.current_state.name == "Idle":
		state_machine.transition_to("Alerted")


func _ready() -> void:
	health_label.text = str(_health)
	call_deferred("_seeker_setup")
	state_machine.log_state_transitions = log_state_transitions


func _physics_process(_delta: float) -> void:
	if _player:
		navigation_agent.target_position = _player.global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var direction_to_next_path_position: Vector2 = global_position.direction_to(
			next_path_position
		)
		navigation_agent.set_velocity(direction_to_next_path_position * CorvidStepState.STEP_SPEED)

	move_and_slide()


func _seeker_setup() -> void:
	await get_tree().physics_frame

	_player = get_tree().get_first_node_in_group("player")
	navigation_agent.target_position = _player.global_position
