class_name Golem

extends Enemy

var _player: Player

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer
@onready var state_machine: GolemStateMachine = $GolemStateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_detector: PlayerDetector = $PlayerDetector


func take_damage(amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	health_component.subtract_health(amount)
	if health_component.current_health > 0:
		shader_animation_player.play("hurt_flash")
	else:
		shader_animation_player.play("death_flash")


func alert() -> void:
	if state_machine.current_state.name == "Idle":
		state_machine.transition_to("Alerted")


func _physics_process(_delta: float) -> void:
	move_and_slide()

	if _player:
		navigation_agent.target_position = _player.global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var direction_to_next_path_position: Vector2 = global_position.direction_to(
			next_path_position
		)
		navigation_agent.set_velocity(direction_to_next_path_position * CorvidStepState.STEP_SPEED)


func _ready() -> void:
	call_deferred("_seeker_setup")
	health_component.health_depleted.connect(func() -> void: state_machine.transition_to("Death"))


func _seeker_setup() -> void:
	await get_tree().physics_frame

	_player = get_tree().get_first_node_in_group("player")
	navigation_agent.target_position = _player.global_position


func _on_player_detector_player_detected() -> void:
	player_detector.monitoring = false
	alert()
