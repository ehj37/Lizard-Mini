extends WispState

@onready var death_particle_burst_resource := preload(
	"res://scenes/enemies/wisp/death_particle_burst/death_particle_burst.tscn"
)
@onready
var death_smoke_resource := preload("res://scenes/enemies/wisp/death_smoke/death_smoke.tscn")


func enter(_data := {}) -> void:
	wisp.hitbox.disable()
	wisp.hurtbox.disable()

	var death_particle_burst = death_particle_burst_resource.instantiate() as Node2D
	death_particle_burst.global_position = wisp.global_position
	wisp.owner.add_child(death_particle_burst)

	wisp.velocity = Vector2.ZERO
	var mod_tween = get_tree().create_tween()
	var lifetime = wisp.fire_small.lifetime
	mod_tween.tween_property(wisp.sprite_shadow, "modulate", Color.TRANSPARENT, lifetime / 3)
	wisp.fire_small.emitting = false
	await get_tree().create_timer(lifetime).timeout

	var death_smoke = death_smoke_resource.instantiate() as Sprite2D
	death_smoke.global_position = wisp.global_position
	wisp.owner.add_child(death_smoke)

	wisp.queue_free()
