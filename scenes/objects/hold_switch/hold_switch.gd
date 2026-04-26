class_name HoldSwitch

extends Node2D

signal interaction_complete


func _on_interact_area_interaction_complete() -> void:
	interaction_complete.emit()
