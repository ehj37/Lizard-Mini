shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;


uniform vec4 silhouette_color: source_color = vec4(0, 0, 0, 0.01);
uniform float silhouette_color_tolerance = 0.01;

uniform vec3 hurt_color: source_color = vec3(0.918, 0.0, 0.447);
uniform vec3 death_color: source_color = vec3(1, 0, 0);
uniform vec3 heal_color: source_color = vec3(0.471, 1.0, 0.808);

uniform int event_type: hint_enum("None", "Hurt", "Death", "Heal");

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	
	switch (event_type) {
		case 0:
			vec4 screen_color = texture(screen_texture, SCREEN_UV);
			if(all(lessThan(abs(sprite_color - screen_color), vec4(silhouette_color_tolerance)))) {
				COLOR = sprite_color;
			} else {
				COLOR = vec4(silhouette_color.rgb, silhouette_color.a * sprite_color.a);
			}
			break;
		case 1:
			COLOR = vec4(hurt_color, sprite_color.a);
			break;
		case 2:
			COLOR = vec4(death_color, sprite_color.a);
			break;
		case 3:
			COLOR = vec4(heal_color, sprite_color.a);
			break;
		}
}

