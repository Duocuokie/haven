shader_type canvas_item;

//baseline at y = 8
// 7 dark palettes
// 6 light palettes

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D colour_table : filter_nearest;
uniform sampler2D lighting_map : filter_nearest;

void fragment() {
	vec4 shadow_colour = texture(TEXTURE, UV);
    vec4 intersected_color = texture(screen_texture, SCREEN_UV);
	highp float red = (intersected_color.r);
	highp float green = (intersected_color.g);
	highp float index = texture(colour_table, vec2(red, green)).r;
	highp float shade_red = (shadow_colour.r);
	highp float shade_value = 21.9-(((shade_red * 255.0)/10.0));
    vec4 output = texture(lighting_map, vec2(index+0.1/255.0, shade_value/18.0));


    COLOR.rgba = output;
	COLOR.a = texture(TEXTURE, UV).a;
    

}
