extends CorvidState

@onready var _death_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/enemies/corvid/sound_effects/corvid_death.tres"
)


func update(_delta: float) -> void:
	if !corvid.animation_player.is_playing():
		corvid.z_index = -3
		corvid.process_mode = Node.PROCESS_MODE_DISABLED


func enter(_data: Dictionary = {}) -> void:
	SoundEffectManager.play_at(_death_sound_effect_config, corvid.global_position)
	corvid.sprite_shadow.visible = false
	corvid.velocity = Vector2.ZERO
	corvid.collision_shape.disabled = true
	corvid.hurtbox.disable()
	corvid.hurtbox_ground.disable()
	corvid.hitbox.disable()
	corvid.animation_player.play("death")
