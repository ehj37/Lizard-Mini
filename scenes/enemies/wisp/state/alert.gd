extends WispState

const ALERT_TIME := 0.15
const TARGET_COLOR := Color("#FD0D00")

var _color: Color
var _color_tween: Tween
var _particle_color_ramp: GradientTexture1D
var _sprite_texture: GradientTexture2D
var _sprite_shadow_texture: GradientTexture2D


func update(_delta: float) -> void:
	_particle_color_ramp.gradient.set_color(0, _color)

	# The second one is so the edges of the texture aren't a low opacity light
	# blue in spite of the color change.
	_sprite_texture.gradient.set_color(0, _color)
	_sprite_texture.gradient.set_color(1, Color(_color, 0.0))

	_sprite_shadow_texture.gradient.set_color(0, _color)
	_sprite_shadow_texture.gradient.set_color(1, Color(_color, 0.0))

	if !_color_tween.is_running():
		state_machine.transition_to("Pursue")


func enter(_data := {}) -> void:
	var process_material = wisp.fire_small.process_material as ParticleProcessMaterial
	_particle_color_ramp = process_material.color_ramp as GradientTexture1D
	_color = _particle_color_ramp.gradient.get_color(0)

	_color_tween = get_tree().create_tween()
	_color_tween.tween_property(self, "_color", TARGET_COLOR, ALERT_TIME)

	_sprite_texture = wisp.sprite.texture as GradientTexture2D
	_sprite_shadow_texture = wisp.sprite_shadow.texture as GradientTexture2D

	# Gets set back to normal amount on exit
	wisp.fire_small.amount *= 2

	AudioManager.play_effect_at(wisp.global_position, SoundEffectConfiguration.Type.WISP_ALERT)


func exit() -> void:
	# Setting back to normal amount after doubling on enter
	wisp.fire_small.amount /= 2
