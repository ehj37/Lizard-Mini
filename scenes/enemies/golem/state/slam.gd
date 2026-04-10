extends GolemState

var _is_combo: bool

@onready var slam_area_packed_scene: PackedScene = preload(
	"res://scenes/enemies/golem/slam_area/slam_area.tscn"
)

@onready var slam_sound_effect_config: SoundEffectConfig = preload(
	"res://scenes/enemies/golem/sound_effects/golem_slam.tres"
)


func update(_delta: float) -> void:
	if !golem.animation_player.is_playing():
		transition_to("PostSlam", {"can_combo": !_is_combo})


func enter(data: Dictionary = {}) -> void:
	_is_combo = data.get("is_combo", false)

	SignalBus.shake_camera.emit()
	golem.animation_player.play("slam")
	SoundEffectManager.play_at(slam_sound_effect_config, golem.global_position)

	var slam_area: SlamArea = slam_area_packed_scene.instantiate()
	slam_area.global_position = golem.global_position
	LevelManager.current_level.add_child(slam_area)
