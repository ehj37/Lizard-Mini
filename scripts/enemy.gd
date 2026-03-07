class_name Enemy

extends CharacterBody2D

@warning_ignore("unused_signal")
signal death

var alerted: bool = false


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	pass


func alert() -> void:
	pass
