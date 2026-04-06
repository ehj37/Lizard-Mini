@tool

extends Node2D

@onready var pot_a_packed_scene: PackedScene = preload("res://scenes/objects/pots/pot_a/pot_a.tscn")
@onready var pot_b_packed_scene: PackedScene = preload("res://scenes/objects/pots/pot_b/pot_b.tscn")
@onready var pot_c_packed_scene: PackedScene = preload("res://scenes/objects/pots/pot_c/pot_c.tscn")
@onready var pot_d_packed_scene: PackedScene = preload("res://scenes/objects/pots/pot_d/pot_d.tscn")


func _ready() -> void:
	# _ready may be called on editor startup if this file is open, the editor
	# gets closed, and then the editor is reopened.
	# In that scenario, a crash will happen without this guard.
	if get_tree().edited_scene_root == null:
		return

	_self_replace.call_deferred()


func _self_replace() -> void:
	# If dragging in the scene from the filesystem, this code gets called, but
	# owner is null. Leading to some angry red messages in the editor, which
	# isn't really a big deal (things still work), but it's annoying.
	if owner == null:
		return

	var pot_packed_scene: PackedScene = (
		[pot_a_packed_scene, pot_b_packed_scene, pot_c_packed_scene, pot_d_packed_scene]
		. pick_random()
	)
	var pot: Pot = pot_packed_scene.instantiate()
	pot.global_position = global_position
	add_sibling(pot, true)
	pot.owner = get_tree().edited_scene_root
	queue_free()
