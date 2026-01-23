extends Area2D

@export var enemies: Array[Enemy] = []


func _on_body_entered(_body: Node2D) -> void:
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.alert()

	queue_free()
