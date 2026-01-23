class_name SnailState

extends State

var snail: Snail


func _ready() -> void:
	await owner.ready

	snail = owner
