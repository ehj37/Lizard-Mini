extends Sprite2D

@onready var silhouette: Sprite2D = $Silhouette


func _ready() -> void:
	silhouette.flip_h = flip_h
	silhouette.hframes = hframes
	silhouette.offset = offset
	silhouette.texture = texture
	silhouette.vframes = vframes

	# Has to go after hframes and vframes are set.
	silhouette.frame = frame

	silhouette.visible = true


func _set(property: StringName, value: Variant) -> bool:
	match property:
		"flip_h":
			silhouette.flip_h = value
		"frame":
			silhouette.frame = value
		"hframes":
			silhouette.hframes = value
		"offset":
			silhouette.offset = value
		"texture":
			silhouette.texture = value
		"vframes":
			silhouette.vframes = value

	return false
