extends Node2D

const DELAY_BETWEEN_SQUARES = 0.6
const DELAY_BETWEEN_WAVES = 1.0
const KILL_TIME = 0.3

@export var num_squares := 4

var _squares: Array[SingleSquare] = []

@onready var single_square_resource := preload("./single_square/single_square.tscn")


func _ready() -> void:
	for i in num_squares:
		var square: SingleSquare = single_square_resource.instantiate()
		add_child(square)
		_squares.append(square)

	_wave()


func _wave() -> void:
	for i in _squares.size():
		if i > 0:
			await get_tree().create_timer(DELAY_BETWEEN_SQUARES).timeout

		var square := _squares[i]
		square.expand()

	var last_square: SingleSquare = _squares.back()
	await last_square.finished

	await get_tree().create_timer(DELAY_BETWEEN_WAVES).timeout

	_wave()


func kill() -> void:
	var alpha_tween := get_tree().create_tween()
	alpha_tween.tween_property(self, "modulate", Color.TRANSPARENT, KILL_TIME)
	await alpha_tween.finished

	queue_free()
