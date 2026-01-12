extends Node2D


func _on_hitbox_blood_drawn():
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.SINGE)
