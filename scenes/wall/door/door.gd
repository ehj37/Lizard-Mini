class_name Door

extends StaticBody2D

@export var progress_indicator: ProgressIndicator

@onready var sprite: Sprite2D = $ColorRect/Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var interact_area: InteractArea = $InteractArea


func _ready() -> void:
	interact_area.progress_indicator = progress_indicator
	interact_area.interaction_complete.connect(_unlock)


func _unlock() -> void:
	AudioManager.play_effect_at(global_position, SoundEffectConfiguration.Type.DOOR_DOWN)

	var sprite_pos_tween = get_tree().create_tween()
	sprite_pos_tween.tween_property(sprite, "position:y", 86, 1.5).set_trans(Tween.TRANS_CUBIC)
	await sprite_pos_tween.finished

	sprite.z_index = -4

	collision_shape.disabled = true
