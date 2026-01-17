extends Node2D

const ENABLED_COLOR := Color("00a9b3")
const DISABLED_COLOR := Color("01262a")

@onready var color_rect: ColorRect = $ColorRect
@onready var fire_particles: GPUParticles2D = $GPUParticles2D
@onready var smoke_particles: GPUParticles2D = $SmokeParticles
@onready var hitbox: Hitbox = $Hitbox


func enable() -> void:
	fire_particles.emitting = true
	hitbox.enable()
	get_tree().create_tween().tween_property(color_rect, "color", ENABLED_COLOR, 0.5)


func disable() -> void:
	fire_particles.emitting = false
	hitbox.disable()
	get_tree().create_tween().tween_property(color_rect, "color", DISABLED_COLOR, 0.5)
	smoke_particles.emitting = true


func _on_hitbox_blood_drawn():
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.SINGE)
