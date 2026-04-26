extends StaticBody2D

const _ENABLED_COLOR: Color = Color("00a9b3")
const _DISABLED_COLOR: Color = Color("01262a")

var _ambience_sound_effect_identifier: int
var _on: bool = true

@onready var on_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/floor/fire_vent/sound_effects/fire_vent_on.tres"
)
@onready var _color_rect: ColorRect = $ColorRect
@onready var _fire_particles: GPUParticles2D = $GPUParticles2D
@onready var _smoke_particles: GPUParticles2D = $SmokeParticles
@onready var _hitbox: Hitbox = $Hitbox


func _ready() -> void:
	_play_ambience()


func toggle() -> void:
	if _on:
		disable()
	else:
		enable()


func enable() -> void:
	_on = true
	_play_ambience()
	_fire_particles.emitting = true
	_hitbox.enable()
	get_tree().create_tween().tween_property(_color_rect, "color", _ENABLED_COLOR, 0.5)


func disable() -> void:
	_on = false
	_stop_ambience()
	_fire_particles.emitting = false
	_hitbox.disable()
	get_tree().create_tween().tween_property(_color_rect, "color", _DISABLED_COLOR, 0.5)
	_smoke_particles.emitting = true


func _play_ambience() -> void:
	_ambience_sound_effect_identifier = SoundEffectManager.play_at(
		on_sound_effect_config, global_position
	)


func _stop_ambience() -> void:
	SoundEffectManager.cancel(_ambience_sound_effect_identifier)
