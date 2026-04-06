class_name GolemStateMachine

extends StateMachine


func set_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	for state: GolemState in _states:
		state.player = player
