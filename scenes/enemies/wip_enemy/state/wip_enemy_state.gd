class_name WipEnemyState

extends State

var wip_enemy: WipEnemy
var player: Player


func on_ground() -> bool:
	return wip_enemy.ground_detector.has_overlapping_bodies()


func _ready() -> void:
	wip_enemy = owner
