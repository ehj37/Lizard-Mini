class_name EffectsSprite

extends Sprite2D

const FALL_DURATION: float = 0.8
const FALL_OFFSET_AMOUNT: float = 400.0
const FALL_Z_INDEX: int = -5
const FALL_Z_INDEX_CHANGE_TIME: float = 0.15

@onready var _shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer


func apply_fall_offset() -> void:
	var offset_tween: Tween = create_tween()
	offset_tween.set_trans(Tween.TRANS_QUAD)
	offset_tween.set_ease(Tween.EASE_IN)
	offset_tween.tween_property(self, "offset:y", offset.y + FALL_OFFSET_AMOUNT, FALL_DURATION)

	await get_tree().create_timer(FALL_Z_INDEX_CHANGE_TIME).timeout
	z_index = FALL_Z_INDEX


func play_hurt_flash() -> void:
	_shader_animation_player.play("hurt_flash")


func play_death_flash() -> void:
	_shader_animation_player.play("death_flash")
