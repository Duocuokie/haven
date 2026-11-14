shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 effect_coord;
uniform float radius : hint_range(0.0, 120.0, 0.1);
uniform float intensity : hint_range(-2.5, 2.5, 0.1);

//https://godotshaders.com/shader/fisheye-anti-fisheye-camera-effect/
// 95% that thing above 
void fragment(){
	// resolution of screen
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 fragCoord = FRAGCOORD.xy;
	
	vec2 p = fragCoord.xy / iResolution.x;
	
	// screen proportions (ratio)
	float prop = iResolution.x / iResolution.y;
	
	// lens position
	vec2 effect_uv = vec2(effect_coord/iResolution);
	effect_uv.y = effect_uv.y/prop;
	
	// effect uv to p
	vec2 d = p - effect_uv;
	
	float dist = sqrt(dot(d,d));
	
	float bind; // zero clue what this means
	if (intensity > 0.0)
		bind = sqrt(dot(effect_uv, effect_uv));
	else {
		if (prop < 1.0) 
    		bind = effect_uv.x; 
    	else 
        	bind = effect_uv.y;
	}

	
	vec2 uv;
	if (intensity > 0.0)
		uv = mix(p, effect_uv + normalize(d) * tan(dist * intensity) * bind / tan( bind * intensity), max(radius - dist, 0.0));
	//antifisheye
	else if (intensity < 0.0)
		uv = mix(p, effect_uv + normalize(d) * atan(dist * -intensity * 10.0) * bind / atan(-intensity * bind * 10.0), max(radius - dist, 0.0));
	//no effect for power = 1.0
	else
		uv = p;
	uv.y *= prop;
	
	COLOR = textureLod(screen_texture, uv, 0.0);
	
}