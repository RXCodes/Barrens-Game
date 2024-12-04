shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// compute the color
	vec4 c = texture(screen_texture, SCREEN_UV);
	if (c.rgba == vec4(0.0, 0.0, 0.0, 1.0)) {
		c.rgb = vec3(1.0, 0.85, 0.3);
	} else {
		c.rgb = vec3(1.0, 1.0, 0.75);
	}
	
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
}