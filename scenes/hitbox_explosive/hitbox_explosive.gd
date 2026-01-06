extends Hitbox


func damage_direction(hurtbox: Hurtbox) -> Vector2:
	return global_position.direction_to(hurtbox.global_position)
