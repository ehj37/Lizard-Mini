extends StaticBody2D

const ENABLED_COLOR: Color = Color("00a9b3")
const DISABLED_COLOR: Color = Color("01262a")

var _ambience_sound_effect_identifier: int

@onready var on_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/floor/fire_vent/sound_effects/fire_vent_on.tres"
)
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
	_ambience_sound_effect_identifier = SoundEffectManager.play_at(
		on_sound_effect_config, global_position
	)


func _stop_ambience() -> void:
	SoundEffectManager.cancel(_ambience_sound_effect_identifier)
