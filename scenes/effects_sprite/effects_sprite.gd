class_name EffectsSprite

extends Sprite2D

const FALL_DURATION: float = 0.768
const FALL_OFFSET_AMOUNT: float = 400.0
const FALL_Z_INDEX: int = -5
const FALL_Z_INDEX_CHANGE_TIME: float = 0.15

var _initial_offset: Vector2 = offset
var _initial_z_index: int = z_index
var _offset_tween: Tween

@onready var _shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer


func apply_fall_offset_and_z_index() -> void:
	_offset_tween = create_tween()
	_offset_tween.set_trans(Tween.TRANS_QUAD)
	_offset_tween.set_ease(Tween.EASE_IN)
	_offset_tween.tween_property(self, "offset:y", offset.y + FALL_OFFSET_AMOUNT, FALL_DURATION)

	await get_tree().create_timer(FALL_Z_INDEX_CHANGE_TIME).timeout
	z_index = FALL_Z_INDEX


func reset_fall_offset_and_z_index() -> void:
	if _offset_tween.is_valid():
		_offset_tween.kill()

	offset = _initial_offset
	z_index = _initial_z_index


func play_hurt_flash() -> void:
	_shader_animation_player.play("hurt_flash")


func play_death_flash() -> void:
	_shader_animation_player.play("death_flash")


func flicker(duration: float) -> void:
	_shader_animation_player.play("blink")
	await get_tree().create_timer(duration).timeout

	_shader_animation_player.stop()
	var shader_material: ShaderMaterial = self.material
	shader_material.set_shader_parameter("enabled", false)
