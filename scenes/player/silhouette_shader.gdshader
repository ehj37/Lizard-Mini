shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;


uniform vec4 silhouette_color: source_color = vec4(0, 0, 0, 0.25);
uniform float silhouette_color_tolerance = 0.01;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	if(all(lessThan(abs(sprite_color - screen_color), vec4(silhouette_color_tolerance)))) {
		COLOR = sprite_color;
	} else {
		COLOR = vec4(silhouette_color.rgb, silhouette_color.a * sprite_color.a);
	}
}
