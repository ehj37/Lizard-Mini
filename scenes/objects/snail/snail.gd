class_name Snail

extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var initial_x: float = global_position.x
@onready var state_machine: StateMachine = $StateMachine
@onready var hide_timer: Timer = $HideTimer


func take_damage(_amount: int, _type: Hitbox.DamageType, _direction: Vector2):
	# If already hiding, stay in shell
	if state_machine.current_state.name == "Hide":
		hide_timer.start()
		return

	state_machine.transition_to("Hide")
