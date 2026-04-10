class_name SlamArea

extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox


func _ready() -> void:
	animation_player.play("dissipate")

	# physics_frame fires BEFORE _physics_process
	# First await gets us to just before first _physics_process
	# Second gets us to after first _physics_process, at which point hurtboxes
	# update their overlapping hitboxes.
	# Third await gets us to after second _physics_process, giving hurtboxes
	# a chance to take damage from hitboxes.
	# Immediate free after second _physics_process will update hurtbox
	# hitboxes overlapping prior to third _physics_process, preventing double
	# damage.
	#
	# Probably way too complicated for what I need. But it seems to work for
	# now, and hopefully I'll notice if and when it breaks down.

	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	hitbox.free()
	await animation_player.animation_finished

	queue_free()
