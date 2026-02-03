extends Node


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("break"):
		# GDFormat is terribly unhappy with this.
		# breakpoint
		pass
