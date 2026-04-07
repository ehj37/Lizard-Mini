extends WispState

@onready var death_particle_burst_resource: PackedScene = preload(
	"res://scenes/enemies/wisp/death_particle_burst/death_particle_burst.tscn"
)
@onready var death_smoke_resource: PackedScene = preload(
	"res://scenes/enemies/wisp/death_smoke/death_smoke.tscn"
)
@onready var _death_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/enemies/wisp/sound_effects/wisp_death.tres"
)


func enter(_data: Dictionary = {}) -> void:
	wisp.velocity = Vector2.ZERO
	wisp.hitbox.disable()
	wisp.hurtbox.disable()
	wisp.collision_shape.disabled = true

	var death_particle_burst: Node2D = death_particle_burst_resource.instantiate()
	death_particle_burst.global_position = wisp.global_position
	LevelManager.current_level.add_child(death_particle_burst)

	SoundEffectManager.play_at(_death_sound_effect_config, wisp.global_position)

	var lifetime: float = wisp.fire_small.lifetime

	var shadow_mod_tween: Tween = get_tree().create_tween()
	shadow_mod_tween.tween_property(wisp.sprite_shadow, "modulate", Color.TRANSPARENT, lifetime / 3)

	var sprite_mod_tween: Tween = get_tree().create_tween()
	sprite_mod_tween.tween_property(wisp.sprite, "modulate", Color.TRANSPARENT, lifetime / 3)

	wisp.fire_small.emitting = false
	await get_tree().create_timer(lifetime, false).timeout

	var death_smoke: Sprite2D = death_smoke_resource.instantiate()
	death_smoke.global_position = wisp.global_position
	LevelManager.current_level.add_child(death_smoke)

	wisp.queue_free()
