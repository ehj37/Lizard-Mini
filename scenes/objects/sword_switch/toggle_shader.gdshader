shader_type canvas_item;


uniform vec3 toggle_color: source_color = vec3(0.918, 0.0, 0.447);
uniform int event_type: hint_enum("None", "Toggle");

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	
	switch (event_type) {
		case 0:
			COLOR = sprite_color;
			break;
		case 1:
			COLOR = vec4(toggle_color, sprite_color.a);
			break;
		}
}

