# CONNECTED toggle boxes will emit signals based on what other toggle boxes
# are registered, while INDEPENDENT toggle boxes emit regardless of any other
# registered toggle box.
#
# E.g. for CONNECTED boxes, if multiple are registered at the same time, then
# only the first registration will cause a toggle to be emitted, and only
# when the last is unregistered will another toggle be emitted.
# For INDEPENDENT boxes, registration/unregistration always causes a toggle
# emission.
#
# The rationale for this: it may be the case that multiple timer switches are
# connected to the same toggle boxes/platforms. If the first switch is hit and
# then the second switch is hit before the first times out, then the player
# expectation for a CONNECTED system would be "since I hit the second timer
# I've extended the time that these platforms are toggled on." But if each
# timer independently toggled platforms, then that "time extension" behavior
# wouldn't happen.
#
# However, that independence behavior makes for some interesting scenarios,
# which is why I've left it in as an option.
# For a non-timer based toggle system, these toggle boxes are likely overkill.

class_name ToggleBox

extends Node

@warning_ignore("unused_signal")
signal toggled

enum Behavior { CONNECTED, INDEPENDENT }

@export var behavior: Behavior
