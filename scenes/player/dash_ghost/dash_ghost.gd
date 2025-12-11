class_name PlayerDashGhost

extends Node2D

const INITIAL_SPEED := 50.0
const DECELERATION := 100.0

var direction: Vector2
var animation: String
var flip_h: bool
var _current_speed: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta):
	position += direction * _current_speed * delta
	_current_speed = max(_current_speed - delta * DECELERATION, 0)


func _ready():
	_current_speed = INITIAL_SPEED

	animation_player.play(animation)
	sprite.flip_h = flip_h

	var fuchsia_tween = get_tree().create_tween()
	fuchsia_tween.tween_property(self, "modulate", Color.FUCHSIA, 0.1)
	await fuchsia_tween.finished

	var cyan_tween = get_tree().create_tween()
	cyan_tween.tween_property(self, "modulate", Color.CYAN, 0.1)
	await cyan_tween.finished

	var fuchsia_tween_2 = get_tree().create_tween()
	fuchsia_tween_2.tween_property(self, "modulate", Color.FUCHSIA, 0.1)
	await fuchsia_tween_2.finished

	queue_free()
