@tool

class_name CorvidPlayerDetector

extends Area2D

signal player_detected

enum DetectorOrientation { RIGHT, LEFT }

var orientation: DetectorOrientation:
	set(new_value):
		match new_value:
			DetectorOrientation.RIGHT:
				($CollisionPolygon2D as CollisionPolygon2D).rotation = 0.0
			DetectorOrientation.LEFT:
				($CollisionPolygon2D as CollisionPolygon2D).rotation = PI
		orientation = new_value
var _player: Player
var _player_in_area: bool = false

@onready var ray_cast: RayCast2D = $RayCast2D


func _physics_process(_delta: float) -> void:
	if !_player_in_area:
		return

	ray_cast.target_position = to_local(_player.global_position)
	ray_cast.force_raycast_update()

	if ray_cast.get_collider() is Player:
		player_detected.emit()


func _on_body_entered(player: Player) -> void:
	_player_in_area = true
	_player = player


func _on_body_exited(_p: Player) -> void:
	_player_in_area = false
