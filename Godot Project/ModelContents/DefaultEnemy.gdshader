shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness = 0.0;

void fragment() {
	// compute the color
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	c.rgb += brightness;
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
}