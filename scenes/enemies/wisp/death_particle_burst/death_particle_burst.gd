extends Node2D

@onready var gpu_particles = $GPUParticles2D


func _ready():
	gpu_particles.emitting = true
	await gpu_particles.finished

	queue_free()
