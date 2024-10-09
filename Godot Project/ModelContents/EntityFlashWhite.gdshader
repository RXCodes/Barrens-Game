shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float normalizedRandom;

void fragment() {
	// compute the color
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	if (c.rgba == vec4(0.0, 0.0, 0.0, 1.0)) {
		c.rgb = vec3(1.0);
	} else {
		c.rgb += (vec3(1.0) - c.rgb) * normalizedRandom;
	}
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
}