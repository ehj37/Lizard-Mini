class_name SwordTimerSwitch

extends StaticBody2D

enum Phase { REGULAR, FAST, PANICKED }

const BASE_TICK_DURATION: float = 0.4
const BASE_NUM_TICKS: int = 4
const PHASE_TO_TICK_DURATION: Dictionary = {
	Phase.REGULAR: BASE_TICK_DURATION,
	Phase.FAST: BASE_TICK_DURATION / 2.0,
	Phase.PANICKED: BASE_TICK_DURATION / 4.0
}
const PHASE_TO_NUM_TICKS: Dictionary = {
	Phase.REGULAR: BASE_NUM_TICKS,
	Phase.FAST: BASE_NUM_TICKS * 2,
	Phase.PANICKED: BASE_NUM_TICKS * 4
}

@export var toggle_boxes: Array[ToggleBox]

var _active: bool = false
var _phase: Phase = Phase.REGULAR
var _current_phase_ticks: int

@onready var _color_rect: ColorRect = $ColorRect
@onready var _tick_timer: Timer = $TickTimer

@onready var _start_sound_effect_config: SoundEffectConfig = preload("./sound_effects/start.tres")
@onready
var _timeout_sound_effect_config: SoundEffectConfig = preload("./sound_effects/timeout.tres")
@onready var _tick_sound_effect_config: SoundEffectConfig = preload("./sound_effects/tick.tres")


func _tick() -> void:
	_current_phase_ticks += 1
	SoundEffectManager.play_at(_tick_sound_effect_config, global_position)
	var tick_duration: float = PHASE_TO_TICK_DURATION[_phase]
	_tick_timer.wait_time = tick_duration
	_tick_timer.start()


func _on_hurtbox_hitbox_connected(
	_damage_direction: Vector2, _damage_types: Array[Hitbox.DamageType]
) -> void:
	if !_active:
		# If _active is true, we've already registered the toggle boxes and
		# toggled them if relevant. We don't want to double toggle and land
		# in a weird state.
		ToggleBoxManager.register_toggle_boxes(toggle_boxes)
		_color_rect.color = Color.BLUE
		_active = true

	SoundEffectManager.play_at(_start_sound_effect_config, global_position)
	_phase = Phase.REGULAR
	_current_phase_ticks = 0
	_tick()


func _on_tick_timer_timeout() -> void:
	if _current_phase_ticks == PHASE_TO_NUM_TICKS[_phase]:
		match _phase:
			Phase.REGULAR:
				_phase = Phase.FAST
				_current_phase_ticks = 0
			Phase.FAST:
				_phase = Phase.PANICKED
				_current_phase_ticks = 0
			Phase.PANICKED:
				_color_rect.color = Color.WHITE
				ToggleBoxManager.unregister_toggle_boxes(toggle_boxes)
				SoundEffectManager.play_at(_timeout_sound_effect_config, global_position)
				_active = false
				return

	_tick()
