class_name WipEnemy

extends Enemy

#const STEP_SPEED = 75.0

const MAX_HEALTH = 3

@export var log_state_transitions := false

var _player: Player
var _health := MAX_HEALTH

@onready var state_machine: WipEnemyStateMachine = $WipEnemyStateMachine
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_ground: Hurtbox = $HurtboxGround
@onready var hitbox_ground: Hitbox = $HitboxGround
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ground_detector: Area2D = $GroundDetector
@onready var health_label: Label = $HealthLabel


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	# To consider: burn?
	# Probably not the best way of doing this since (from the other enemy's perspective)
	# the attack will have landed (i.e. take_damage was called).
	var relevant_damage_types := _types.filter(
		func(type: Hitbox.DamageType) -> bool: return type != Hitbox.DamageType.ENEMY
	)
	if relevant_damage_types.is_empty():
		return

	_health -= 1
	health_label.text = str(_health)
	if _health <= 0:
		state_machine.transition_to("Death")


func _ready() -> void:
	health_label.text = str(_health)
	call_deferred("_seeker_setup")
	state_machine.log_state_transitions = log_state_transitions


func _physics_process(_delta: float) -> void:
	if _player:
		navigation_agent.target_position = _player.global_position
		var next_path_position := navigation_agent.get_next_path_position()
		var direction_to_next_path_position := global_position.direction_to(next_path_position)
		navigation_agent.set_velocity(
			direction_to_next_path_position * WipEnemyStepState.STEP_SPEED
		)

	move_and_slide()


func _seeker_setup() -> void:
	await get_tree().physics_frame

	_player = get_tree().get_first_node_in_group("player")
	navigation_agent.target_position = _player.global_position
