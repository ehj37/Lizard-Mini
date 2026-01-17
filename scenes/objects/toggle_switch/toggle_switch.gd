extends StaticBody2D

const TIME_BETWEEN_TOGGLES := 0.75
const GLYPH_COLOR_TWEEN_DURATION := 0.5
const GLYPHS_ENABLED_COLOR := Color("00f0fd")
const GLYPHS_DISABLED_COLOR := Color("01262a")

@export var toggled_on: bool
@export var toggleable_elements: Array[Node2D]

@onready var sprite_glyphs: Sprite2D = $SpriteGlyphs
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: InteractArea = $InteractArea
@onready var progress_indicator: ProgressIndicator = $ProgressIndicator


func _ready() -> void:
	if toggled_on:
		animation_player.play("on")
		sprite_glyphs.modulate = GLYPHS_ENABLED_COLOR
	else:
		animation_player.play("off")
		sprite_glyphs.modulate = GLYPHS_DISABLED_COLOR

	for toggleable_element in toggleable_elements:
		assert(toggleable_element.has_method("enable"), "Toggleable element must implement enable")
		assert(
			toggleable_element.has_method("disable"), "Toggleable element must implement disable"
		)

	interact_area.interaction_complete.connect(_toggle)


func _toggle() -> void:
	for toggleable_element in toggleable_elements:
		if toggled_on:
			toggleable_element.disable()
			animation_player.play("disable")
			var glyphs_tween = get_tree().create_tween()
			glyphs_tween.tween_property(
				sprite_glyphs, "modulate", GLYPHS_DISABLED_COLOR, GLYPH_COLOR_TWEEN_DURATION
			)
		else:
			toggleable_element.enable()
			animation_player.play("enable")
			var glyphs_tween = get_tree().create_tween()
			glyphs_tween.tween_property(
				sprite_glyphs, "modulate", GLYPHS_ENABLED_COLOR, GLYPH_COLOR_TWEEN_DURATION
			)

	toggled_on = !toggled_on

	get_tree().create_timer(TIME_BETWEEN_TOGGLES).timeout.connect(func(): interact_area.enable())
