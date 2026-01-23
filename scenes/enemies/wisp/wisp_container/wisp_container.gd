class_name WispContainer

extends StaticBody2D

var popped := false

@onready var wisp: Wisp = $Wisp
@onready var sprite_back: Sprite2D = $SpriteBack
@onready var sprite_front: Sprite2D = $SpriteFront
@onready var gpu_particles: GPUParticles2D = $GPUParticles2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var fragment_spawner: FragmentSpawner = $FragmentSpawner


func shatter(direction := Vector2.ZERO) -> void:
	popped = true
	collision_polygon.set_deferred("disabled", true)
	sprite_back.visible = false
	sprite_front.visible = false
	gpu_particles.emitting = true
	fragment_spawner.spawn_fragments(direction)
	hurtbox.disable()

	if is_instance_valid(wisp):
		wisp.alert()


func take_damage(_amount: int, _type: Hitbox.DamageType, direction: Vector2) -> void:
	shatter(direction)
