extends Node

var _registered_areas: Array[InteractArea] = []


func register_area(interact_area: InteractArea) -> void:
	_registered_areas.append(interact_area)


func unregister_area(interact_area: InteractArea) -> void:
	_registered_areas.erase(interact_area)


# Returns null if there are no registered areas.
func get_interact_area():
	if _registered_areas.size() == 0:
		return

	return _registered_areas.get(_registered_areas.size() - 1)
