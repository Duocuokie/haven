shader_type canvas_item;

uniform vec2 center_uv;
uniform float radius: hint_range(0.0, 1.0, 0.01);
uniform float power : hint_range(0.5, 2.0, 0.1);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
// https://www.geeks3d.com/20140213/glsl-shader-library-fish-eye-and-dome-and-barrel-distortion-post-processing-filters/6/

void fragment() {
	float dist = distance(SCREEN_UV, center_uv);
	float a = max(radius-dist, 0.0);
	vec2 unit = normalize(SCREEN_UV - center_uv);
	vec2 sample_uv = mix(SCREEN_UV, center_uv + unit * atan(dist * -power), a);
	COLOR = textureLod(screen_texture, sample_uv, 0.0);
}
