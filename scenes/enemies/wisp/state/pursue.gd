extends WispState

const MAX_SPEED := 150.0
const ACCELERATION := 150.0

var _player: Player
var _current_speed: float = 0.0


func update(delta: float) -> void:
	_current_speed = min(_current_speed + ACCELERATION * delta, MAX_SPEED)
	var to_player = wisp.global_position.direction_to(_player.global_position)
	wisp.velocity = to_player * _current_speed


func enter(_data := {}) -> void:
	_player = get_tree().get_first_node_in_group("player")
