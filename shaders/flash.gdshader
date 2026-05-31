shader_type canvas_item;

uniform bool enabled = false;

uniform vec3 white: source_color = vec3(1.0);
uniform vec3 black: source_color = vec3(0.0);
uniform vec4 transparent: source_color = vec4(0.0);
uniform vec3 hurt_color: source_color = vec3(0.918, 0.0, 0.447);
uniform vec3 death_color: source_color = vec3(1, 0, 0);
uniform vec3 heal_color: source_color = vec3(0.471, 1.0, 0.808);

uniform int color: hint_enum("White", "Black", "Transparent", "Hurt", "Death", "Heal");

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);

	if (!enabled) {
		COLOR = previous_color;
	} else {
		switch (color) {
			case 0:
				COLOR = vec4(white, previous_color.a);
				break;
			case 1:
				COLOR = vec4(black, previous_color.a);
				break;
			case 2:
				COLOR = transparent;
				break;
			case 3:
				COLOR = vec4(hurt_color, previous_color.a);
				break;
			case 4:
				COLOR = vec4(death_color, previous_color.a);
				break;
			case 5:
				COLOR = vec4(heal_color, previous_color.a);
				break;
		}
	}
}
