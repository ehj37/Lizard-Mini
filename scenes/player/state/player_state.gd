class_name PlayerState

extends State

var player: Player
var animation_player: AnimationPlayer


func _ready():
	await owner.ready

	player = owner
	animation_player = player.animation_player
