class_name HoldSwitch

extends Node2D

signal interaction_complete

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _on_interact_area_interaction_complete() -> void:
	_animation_player.play("retract")
	interaction_complete.emit()
