shader_type canvas_item;

//baseline at y = 8
// 7 dark palettes
// 6 light palettes

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D colour_table : filter_nearest;
uniform sampler2D lighting_map : filter_nearest;
varying vec4 vertex_color;
void vertex() {
  vertex_color = COLOR;
}
void fragment() {
    vec4 intersected_color = texture(screen_texture, SCREEN_UV);
	highp float red = (intersected_color.r);
	highp float green = (intersected_color.g);
	highp float index = texture(colour_table, vec2(red, green)).r;
	highp float shade_red = (vertex_color.r);
	//highp float shade_value = 21.9-((shade_red * 255.0)/10.0);
	highp float shade_value = 21.9-((shade_red * 255.0)/10.0);
	//shade_value = 0.5;
	//index = 0.5;
    //vec4 output = texture(lighting_map, vec2(index+0.1/255.0, 7.5/18.0));
	vec4 output = texture(lighting_map, vec2(index+0.1/255.0, (21.9 -((shade_red * 255.0) / 10.0))/18.0));


    COLOR.rgba = output;
	COLOR.a = texture(TEXTURE, UV).a;


}
