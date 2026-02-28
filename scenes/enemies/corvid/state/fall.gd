extends CorvidState


func update(_delta: float) -> void:
	if !corvid.animation_player.is_playing():
		corvid.queue_free()


func enter(_data: Dictionary = {}) -> void:
	corvid.sprite_shadow.visible = false
	corvid.velocity = Vector2.ZERO
	corvid.collision_shape.disabled = true
	corvid.hurtbox.disable()
	corvid.hurtbox_ground.disable()
	corvid.hitbox.disable()
	corvid.animation_player.play("fall")
