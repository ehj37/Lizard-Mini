class_name WipEnemy

extends Enemy

@onready var state_machine: WipEnemyStateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var color_rect: ColorRect = $ColorRect


func take_damage(amount: int, _types: Array[Hitbox.DamageType], _direction: Vector2) -> void:
	health_component.subtract_health(amount)


func alert() -> void:
	super()

	if state_machine.current_state.name == "Idle":
		state_machine.transition_to("Alerted")


func _physics_process(_delta: float) -> void:
	move_and_slide()
