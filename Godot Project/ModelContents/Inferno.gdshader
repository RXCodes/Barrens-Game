shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform sampler2D noise_texture : filter_linear, repeat_enable;
uniform vec2 scrollAmount = vec2(0.05, 0.05);
uniform float multiplier : hint_range(0.0, 0.1) = 0.01;
uniform float brightness = 0.0;

// Color space conversion from https://godotshaders.com/shader/color-range-swap/
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	// compute the color - use noise to adjust hue and brightness
	vec2 scroll = scrollAmount * TIME;
	vec2 displacement = texture(noise_texture, SCREEN_UV + scroll).rb;
	vec4 c = texture(screen_texture, SCREEN_UV);
	if (c.a < 0.25) {
		c.a = 0.0;
	}
	
	// make this enemy red
	vec3 hsv = rgb2hsv(c.rgb);
	hsv.r += 0.375 + (displacement.x * 0.075);
	hsv.b += -0.1 + (displacement.y * 0.35);
	c.rgb = hsv2rgb(hsv);
	
	c.rgb += brightness;
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
}