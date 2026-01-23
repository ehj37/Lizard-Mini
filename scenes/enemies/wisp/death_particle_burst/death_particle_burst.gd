extends Node2D

@onready var gpu_particles: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	gpu_particles.emitting = true
	await gpu_particles.finished

	queue_free()
