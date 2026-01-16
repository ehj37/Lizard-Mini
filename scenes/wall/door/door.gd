class_name Door

extends StaticBody2D

@onready var dust_cloud_resource := preload("./door_dust_cloud/door_dust_cloud.tscn")
@onready var sprite: Sprite2D = $ColorRect/Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interact_area: InteractArea = $InteractArea
@onready var right_dust_spawn: Marker2D = $RightDustSpawn
@onready var left_dust_spawn: Marker2D = $LeftDustSpawn
@onready var progress_indicator: ProgressIndicator = $ProgressIndicator


func _ready() -> void:
	interact_area.progress_indicator = progress_indicator
	interact_area.interaction_complete.connect(_unlock)


func _unlock() -> void:
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.DOOR_DOWN)

	var right_dust_cloud = dust_cloud_resource.instantiate() as Sprite2D
	right_dust_cloud.global_position = right_dust_spawn.global_position
	owner.add_child(right_dust_cloud)

	var left_dust_cloud = dust_cloud_resource.instantiate() as Sprite2D
	left_dust_cloud.flip_h = true
	left_dust_cloud.global_position = left_dust_spawn.global_position
	owner.add_child(left_dust_cloud)

	var sprite_pos_tween = get_tree().create_tween()
	sprite_pos_tween.tween_property(sprite, "position:y", 86, 1.5).set_trans(Tween.TRANS_CUBIC)
	await sprite_pos_tween.finished

	sprite.z_index = -4

	collision_shape.disabled = true
