@tool

class_name EnemyAlertChainer

extends Area2D

signal alerted_enemy_detected

@export var radius: float:
	set(new_value):
		var shape: CircleShape2D = ($CollisionShape2D as CollisionShape2D).shape
		shape.radius = new_value
		radius = new_value

var _ray_cast_by_enemy: Dictionary = {}


func _physics_process(_delta: float) -> void:
	for enemy: Enemy in _ray_cast_by_enemy:
		if !enemy.alerted:
			continue

		var ray_cast: RayCast2D = _ray_cast_by_enemy[enemy]
		ray_cast.target_position = to_local(enemy.global_position).normalized() * radius
		ray_cast.force_raycast_update()
		if ray_cast.get_collider() is Enemy:
			alerted_enemy_detected.emit()


func _on_body_entered(enemy: Enemy) -> void:
	if enemy == owner:
		return

	var ray_cast: RayCast2D = RayCast2D.new()
	ray_cast.set_collision_mask_value(1, true)  # Obstacle
	ray_cast.set_collision_mask_value(5, true)  # Enemy
	add_child(ray_cast)
	_ray_cast_by_enemy.set(enemy, ray_cast)


func _on_body_exited(enemy: Enemy) -> void:
	var ray_cast: RayCast2D = _ray_cast_by_enemy.get(enemy)
	# Enemies are likely to free their alert chainers on alert.
	# When this gets queue_free'd, it's removed from the scene tree, and this
	# gets called for the owning enemy. Before this is called, though, owner is
	# set to null, so we can't just check owner == enemy.
	if is_instance_valid(ray_cast):
		ray_cast.queue_free()

	_ray_cast_by_enemy.erase(enemy)
