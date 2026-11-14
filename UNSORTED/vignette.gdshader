shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture, filter_nearest, repeat_disable;
uniform vec3 vignette_color: source_color;
uniform float effect_distance: hint_range(0.0, 2.0, 0.01);
uniform float strength: hint_range(0.0, 10.0, 0.1);
void fragment() {
	float dist = distance(SCREEN_UV, vec2(0.5,0.5));
	vec4 col = texture(screen_texture, SCREEN_UV);
	COLOR = col + vec4(dist * vignette_color, 0.0) * min(dist/effect_distance, 1.0) * strength;
}
