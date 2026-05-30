extends Node

# See toggle_box.gd for an explanation of the toggle box system.
# I just know future me will get confused about this, but present me is trying his best.

var _box_registration_counts: Dictionary


# A box being registered may result in the box emitting a "toggled" signal
# depending on the box's behavior and if the box has been registered already.
func register_toggle_boxes(toggle_boxes: Array[ToggleBox]) -> void:
	for toggle_box: ToggleBox in toggle_boxes:
		var registration_count_for_box: int = _box_registration_counts.get(toggle_box, 0) + 1
		_box_registration_counts[toggle_box] = registration_count_for_box

		match toggle_box.behavior:
			ToggleBox.Behavior.CONNECTED:
				if registration_count_for_box == 1:
					toggle_box.toggled.emit()
			ToggleBox.Behavior.INDEPENDENT:
				toggle_box.toggled.emit()


# A box being unregistered may result in the box emitting a "toggled" signal
# depending on the box's behavior and if the box had been registered multiple
# times.
func unregister_toggle_boxes(toggle_boxes: Array[ToggleBox]) -> void:
	for toggle_box: ToggleBox in toggle_boxes:
		var registration_count_for_box: int = _box_registration_counts.get(toggle_box) - 1
		if registration_count_for_box == 0:
			_box_registration_counts.erase(toggle_box)
		else:
			_box_registration_counts[toggle_box] = registration_count_for_box

		match toggle_box.behavior:
			ToggleBox.Behavior.CONNECTED:
				if registration_count_for_box == 0:
					toggle_box.toggled.emit()
			ToggleBox.Behavior.INDEPENDENT:
				toggle_box.toggled.emit()
