shader_type canvas_item;

uniform bool enabled = false;

uniform vec3 hurt_color: source_color = vec3(0.918, 0.0, 0.447);
uniform vec3 death_color: source_color = vec3(1, 0, 0);
uniform vec3 heal_color: source_color = vec3(0.471, 1.0, 0.808);

uniform int event_type: hint_enum("Hurt", "Death", "Heal");

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);

	if (!enabled) {
		COLOR = previous_color;
	} else {
		switch (event_type) {
			case 0:
				COLOR = vec4(hurt_color, previous_color.a);
				break;
			case 1:
				COLOR = vec4(death_color, previous_color.a);
				break;
			case 2:
				COLOR = vec4(heal_color, previous_color.a);
				break;
		}
	}
}