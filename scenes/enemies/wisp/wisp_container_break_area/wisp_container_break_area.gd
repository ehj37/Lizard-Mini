extends Area2D

const TIME_BETWEEN_BREAKS := 1.2

var wisp_containers: Array[WispContainer]


func _ready() -> void:
	for child in get_children():
		if child is WispContainer:
			wisp_containers.append(child)


func _on_body_entered(_body):
	set_deferred("monitoring", false)

	while wisp_containers.size() > 0:
		var container_to_pop = wisp_containers.pick_random()
		wisp_containers.erase(container_to_pop)
		if container_to_pop.popped:
			continue

		container_to_pop.shatter()
		await get_tree().create_timer(TIME_BETWEEN_BREAKS).timeout
		# TODO: Sometimes this is buggy, and two containers pop within a few seconds of each other.
		# Seems to happen when you have multiple wisps going at the same time.
