class_name Fragment

extends RigidBody2D

const INITIAL_VERTICAL_SPEED := -50.0
const GRAVITY := 575.0

var fragment_config: FragmentConfig
var _vertical_speed := INITIAL_VERTICAL_SPEED
var _falling_from_spawn := true
var _falling_into_pit := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = $SpriteShadow
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ground_detector: Area2D = $GroundDetector


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


func _process(delta: float) -> void:
	if _falling_from_spawn:
		_vertical_speed = _vertical_speed + delta * GRAVITY
		var new_y: float = sprite.position.y + _vertical_speed * delta

		if new_y < 0:
			sprite.position.y = new_y
		else:
			_falling_from_spawn = false
			sprite_shadow.visible = false

			if _on_ground():
				sprite.position.y = 0
				_vertical_speed = 0
			else:
				_falling_into_pit = true
				sprite.position.y = new_y

			var scale_tween := get_tree().create_tween()
			scale_tween.tween_property(sprite, "scale", Vector2.ZERO, 3.0)
			scale_tween.finished.connect(queue_free)

	if !_falling_from_spawn && (!_falling_into_pit && !_on_ground()):
		_falling_into_pit = true

	if _falling_into_pit:
		_vertical_speed = _vertical_speed + delta * GRAVITY
		sprite.position.y = sprite.position.y + _vertical_speed * delta


func _on_ground() -> bool:
	return ground_detector.has_overlapping_bodies()
