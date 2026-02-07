extends StaticBody2D

const ENABLED_COLOR := Color("00a9b3")
const DISABLED_COLOR := Color("01262a")

var _ambience_identifier: int

@onready var color_rect: ColorRect = $ColorRect
@onready var fire_particles: GPUParticles2D = $GPUParticles2D
@onready var smoke_particles: GPUParticles2D = $SmokeParticles
@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	_play_ambience()


func enable() -> void:
	_play_ambience()
	fire_particles.emitting = true
	hitbox.enable()
	get_tree().create_tween().tween_property(color_rect, "color", ENABLED_COLOR, 0.5)


func disable() -> void:
	_stop_ambience()
	fire_particles.emitting = false
	hitbox.disable()
	get_tree().create_tween().tween_property(color_rect, "color", DISABLED_COLOR, 0.5)
	smoke_particles.emitting = true


func _play_ambience() -> void:
	_ambience_identifier = AudioManager.play_effect_at(
		global_position, SoundEffectConfiguration.Type.FIRE_VENT
	)


func _stop_ambience() -> void:
	AudioManager.cancel_audio(SoundEffectConfiguration.Type.FIRE_VENT, _ambience_identifier)
