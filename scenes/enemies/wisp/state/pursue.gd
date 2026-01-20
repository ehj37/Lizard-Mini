extends WispState

const MAX_SPEED := 150.0
const ACCELERATION := 200.0
const STEERING_CONST := 2.0

var _player: Player
var _current_speed: float = 0.0
var _current_direction: Vector2


func update(delta: float) -> void:
	_current_speed = min(_current_speed + ACCELERATION * delta, MAX_SPEED)
	var to_player = wisp.global_position.direction_to(_player.global_position)

	_current_direction = _current_direction.move_toward(to_player, delta * STEERING_CONST)
	wisp.velocity = _current_direction * _current_speed


func enter(_data := {}) -> void:
	_player = get_tree().get_first_node_in_group("player")
	_current_direction = wisp.global_position.direction_to(_player.global_position)
	wisp.obstacle_detector.monitoring = true
