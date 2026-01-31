class_name Door

extends StaticBody2D

const DOOR_LOWER_TIME := 1.5
const BACKLIGHT_TWEEN_TIME := 0.2
const LEFT_BACKLIGHT_LIT_UP_COLOR := ColorsOfLizard.FIRE_FUCHSIA
const RIGHT_BACKLIGHT_LIT_UP_COLOR := ColorsOfLizard.FIRE_CYAN

@onready var dust_cloud_resource := preload("./door_dust_cloud/door_dust_cloud.tscn")
@onready var door_visuals: Node2D = $ColorRect/DoorVisuals
@onready var left_backlight: ColorRect = $ColorRect/DoorVisuals/LeftBacklight
@onready var right_backlight: ColorRect = $ColorRect/DoorVisuals/RightBacklight
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interact_area: InteractArea = $InteractArea
@onready var right_dust_spawn: Marker2D = $RightDustSpawn
@onready var left_dust_spawn: Marker2D = $LeftDustSpawn
@onready var progress_indicator: ProgressIndicator = $ProgressIndicator


func _ready() -> void:
	interact_area.interaction_complete.connect(_unlock)


func _unlock() -> void:
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.DOOR_DOWN)

	var right_dust_cloud: Sprite2D = dust_cloud_resource.instantiate()
	right_dust_cloud.global_position = right_dust_spawn.global_position
	LevelManager.current_level.add_child(right_dust_cloud)

	var left_dust_cloud: Sprite2D = dust_cloud_resource.instantiate()
	left_dust_cloud.flip_h = true
	left_dust_cloud.global_position = left_dust_spawn.global_position
	LevelManager.current_level.add_child(left_dust_cloud)

	var left_backlight_tween := get_tree().create_tween()
	left_backlight_tween.tween_property(
		left_backlight, "color", LEFT_BACKLIGHT_LIT_UP_COLOR, BACKLIGHT_TWEEN_TIME
	)

	var right_backlight_tween := get_tree().create_tween()
	right_backlight_tween.tween_property(
		right_backlight, "color", RIGHT_BACKLIGHT_LIT_UP_COLOR, BACKLIGHT_TWEEN_TIME
	)

	var door_visuals_pos_tween := get_tree().create_tween()
	(
		door_visuals_pos_tween
		. tween_property(door_visuals, "position:y", 54, DOOR_LOWER_TIME)
		. set_trans(Tween.TRANS_CUBIC)
	)
	await door_visuals_pos_tween.finished

	door_visuals.z_index = -4
	collision_shape.disabled = true
