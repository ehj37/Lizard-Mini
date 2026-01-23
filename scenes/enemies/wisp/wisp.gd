class_name Wisp

extends Enemy

const OSCILLATION_FREQUENCY := 4.0
const OSCILLATION_AMPLITUDE := 3.0

var oscillating := false
var _elapsed_time := 0.0

@onready var state_machine: StateMachine = $StateMachine
@onready var offset_container: Node2D = $OffsetContainer
@onready var sprite: Sprite2D = $OffsetContainer/Sprite2D
@onready var fire_small: GPUParticles2D = $OffsetContainer/FireSmall
@onready var hitbox: Hitbox = $Hitbox
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var obstacle_detector: Area2D = $ObstacleDetector


func take_damage(_amount: int, _type: Hitbox.DamageType, _direction: Vector2) -> void:
	state_machine.transition_to("Death")


func alert() -> void:
	if state_machine.current_state.name == "Idle":
		state_machine.transition_to("Alert")


func _physics_process(delta: float) -> void:
	if oscillating:
		_elapsed_time += delta
		offset_container.position.y = (
			sin(_elapsed_time * OSCILLATION_FREQUENCY) * OSCILLATION_AMPLITUDE
		)

	move_and_slide()


func _on_hitbox_blood_drawn() -> void:
	if state_machine.current_state.name == "Alert":
		return

	state_machine.transition_to("Death")


func _on_obstacle_detector_body_entered(_body: Node2D) -> void:
	state_machine.transition_to("Death")
