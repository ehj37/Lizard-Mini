@tool

extends StaticBody2D

@export var flame_on := true:
	set(new_flame_on):
		flame_on = new_flame_on
		if Engine.is_editor_hint() && is_node_ready():
			fire.emitting = flame_on

@onready var fire: GPUParticles2D = $FireSmall


func _ready() -> void:
	fire.emitting = flame_on
