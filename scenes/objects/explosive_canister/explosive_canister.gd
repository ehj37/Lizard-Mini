extends StaticBody2D

@onready var explosion_resource := preload("./explosion/explosive_canister_explosion.tscn")
@onready var hurtbox: Hurtbox = $Hurtbox


func take_damage(_amount: int, _type: Hitbox.DamageType, _direction: Vector2) -> void:
	hurtbox.disable()

	var explosion = explosion_resource.instantiate() as Node2D
	explosion.global_position = global_position
	owner.add_child(explosion)

	EventBus.explosion.emit()

	queue_free()
