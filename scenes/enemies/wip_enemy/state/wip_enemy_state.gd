class_name WipEnemyState

extends State

const ATTACK_RANGE: float = 50.0
const HITBOX_ENABLE_DURATION: float = 0.1

var wip_enemy: WipEnemy
var player: Player


func can_attack() -> bool:
	var in_range: bool = (
		wip_enemy.global_position.distance_to(player.global_position) < ATTACK_RANGE
	)
	var cooldown_up: bool = wip_enemy.attack_cooldown_timer.is_stopped()
	return in_range && cooldown_up


func _ready() -> void:
	wip_enemy = owner
