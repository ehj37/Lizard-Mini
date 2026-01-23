extends SnailState

enum MoveDirection { LEFT, RIGHT }

const MOVE_RADIUS := 4

var direction := MoveDirection.RIGHT


func update(_delta: float) -> void:
	if !snail.animation_player.is_playing():
		state_machine.transition_to("Idle")


func enter(_data := {}) -> void:
	snail.animation_player.play("move")


func _move() -> void:
	var movement := snail.global_position.x - snail.initial_x
	match direction:
		MoveDirection.LEFT:
			if movement > -MOVE_RADIUS:
				snail.global_position.x -= 1
			else:
				direction = MoveDirection.RIGHT
				snail.sprite.flip_h = false
		MoveDirection.RIGHT:
			if movement < MOVE_RADIUS:
				snail.global_position.x += 1
			else:
				direction = MoveDirection.LEFT
				snail.sprite.flip_h = true
