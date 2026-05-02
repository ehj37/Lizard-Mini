class_name HitboxSword

extends Hitbox

var orientation: Vector2


func disable() -> void:
	super()
	for child: CollisionPolygon2D in get_children():
		child.disabled = true
		child.visible = false


func damage_direction(_hurtbox: Hurtbox) -> Vector2:
	return orientation
