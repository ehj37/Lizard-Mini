class_name SnailState

extends State

var snail: Snail


func _ready():
	await owner.ready

	snail = owner
