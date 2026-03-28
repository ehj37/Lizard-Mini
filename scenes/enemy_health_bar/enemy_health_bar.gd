class_name EnemyHealthBar

extends Node2D

@export var health_component: HealthComponent

var _pips: Array[EnemyHealthBarPip] = []

@onready var enemy_health_bar_pip_packed_scene: PackedScene = preload(
	"./enemy_health_bar_pip/enemy_health_bar_pip.tscn"
)
@onready var pips_container: HBoxContainer = $PanelContainer/PipsContainer


func _ready() -> void:
	health_component.health_added.connect(func(_amount: int) -> void: _update_pips())
	health_component.health_subtracted.connect(func(_amount: int) -> void: _update_pips())
	health_component.health_depleted.connect(hide)

	for i: int in health_component.max_health:
		var pip: EnemyHealthBarPip = enemy_health_bar_pip_packed_scene.instantiate()
		pips_container.add_child(pip)
		_pips.append(pip)

	_update_pips()


func _update_pips() -> void:
	for i: int in health_component.max_health:
		if i < health_component.current_health:
			_pips[i].set_to_filled()
		else:
			_pips[i].set_to_empty()
