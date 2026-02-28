class_name CorvidState

extends State

var corvid: Corvid
var player: Player


func on_ground() -> bool:
	return corvid.ground_detector.has_overlapping_bodies()


func _ready() -> void:
	corvid = owner
