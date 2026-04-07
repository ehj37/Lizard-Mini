class_name GolemState

extends State

const ATTACK_RANGE: float = 50.0

var golem: Golem
var player: Player


func can_attack() -> bool:
	var in_range: bool = golem.global_position.distance_to(player.global_position) < ATTACK_RANGE
	var cooldown_up: bool = golem.attack_cooldown_timer.is_stopped()
	return in_range && cooldown_up


func _ready() -> void:
	golem = owner
