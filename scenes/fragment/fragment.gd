class_name Fragment

extends RigidBody2D

const INITIAL_VERTICAL_SPEED := -50.0
const GRAVITY := 575.0

var fragment_config: FragmentConfig
var _vertical_speed := INITIAL_VERTICAL_SPEED
var _airborne := true

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow


func _ready() -> void:
	sprite.texture = fragment_config.fragments_texture
	sprite.region_enabled = true
	sprite.region_rect.size.x = fragment_config.fragment_region_width
	sprite.region_rect.size.y = fragment_config.fragment_region_height

	var variant_number := randi_range(0, fragment_config.num_fragment_variants)
	sprite.region_rect.position.x = fragment_config.fragment_region_width * variant_number
	sprite.rotation = randf_range(0, 2 * PI)

	mass = fragment_config.mass
	linear_damp = fragment_config.linear_damp

	gravity_scale = 0.0
	set_deferred("lock_rotation", true)


func _process(delta: float) -> void:
	if !_airborne:
		return

	_vertical_speed = _vertical_speed + delta * GRAVITY
	var new_y: float = min(sprite.position.y + _vertical_speed * delta, 0.0)
	sprite.position.y = new_y

	if new_y == 0:
		_airborne = false
		lock_rotation = false
		sprite_shadow.visible = false

		var scale_tween := get_tree().create_tween()
		scale_tween.tween_property(self, "scale", Vector2.ZERO, 3.0)
		await scale_tween.finished

		queue_free()
