extends GolemState


func enter(_data: Dictionary = {}) -> void:
	golem.animation_player.play("idle")
