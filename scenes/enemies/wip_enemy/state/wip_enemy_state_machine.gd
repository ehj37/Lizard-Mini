class_name WipEnemyStateMachine

extends StateMachine


func set_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	for state: WipEnemyState in _states:
		state.player = player
