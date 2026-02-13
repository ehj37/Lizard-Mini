extends WipEnemyState


func update(_delta: float) -> void:
	if !wip_enemy.animation_player.is_playing():
		state_machine.transition_to("Decide")


func enter(_data := {}) -> void:
	wip_enemy.animation_player.play("alerted")
