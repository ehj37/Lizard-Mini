extends StaticBody2D

signal hit

const _TIME_BETWEEN_TOGGLES: float = 0.75
const _GLYPH_COLOR_TWEEN_DURATION: float = 0.5
const _GLYPHS_ENABLED_COLOR: Color = ColorsOfLizard.FIRE_CYAN
const _GLYPHS_DISABLED_COLOR: Color = Color("01262a")

@export var toggled_on: bool

@onready var _interaction_complete_sound_effect_config: SoundEffectConfig = preload(
	"res://audio/shared_sound_effects/interaction/interaction_complete.tres"
)
@onready var _sprite_glyphs: Sprite2D = $SpriteGlyphs
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _shader_animation_player: AnimationPlayer = $ShaderAnimationPlayer
@onready var _hurtbox: Hurtbox = $Hurtbox


func take_damage(_amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	hit.emit()
	HitStopManager.hit_stop()
	SoundEffectManager.play_at(_interaction_complete_sound_effect_config, global_position)
	_toggle()
	_hurtbox.disable()
	await get_tree().create_timer(_TIME_BETWEEN_TOGGLES).timeout

	_hurtbox.enable()


func _ready() -> void:
	if toggled_on:
		_animation_player.play("on")
		_sprite_glyphs.modulate = _GLYPHS_ENABLED_COLOR
	else:
		_animation_player.play("off")
		_sprite_glyphs.modulate = _GLYPHS_DISABLED_COLOR


func _toggle() -> void:
	_shader_animation_player.play("toggle")
	if toggled_on:
		_animation_player.play("disable")
		var glyphs_tween: Tween = get_tree().create_tween()
		glyphs_tween.tween_property(
			_sprite_glyphs, "modulate", _GLYPHS_DISABLED_COLOR, _GLYPH_COLOR_TWEEN_DURATION
		)
	else:
		_animation_player.play("enable")
		var glyphs_tween: Tween = get_tree().create_tween()
		glyphs_tween.tween_property(
			_sprite_glyphs, "modulate", _GLYPHS_ENABLED_COLOR, _GLYPH_COLOR_TWEEN_DURATION
		)

	toggled_on = !toggled_on
