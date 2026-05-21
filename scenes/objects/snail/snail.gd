class_name Snail

extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var initial_x: float = global_position.x
@onready var state_machine: StateMachine = $StateMachine
@onready var hide_timer: Timer = $HideTimer


func _on_hurtbox_hitbox_connected(
	_damage_direction: Vector2, _damage_types: Array[Hitbox.DamageType]
) -> void:
	if state_machine.current_state.name == "Hide":
		hide_timer.start()
		return

	state_machine.transition_to("Hide")
