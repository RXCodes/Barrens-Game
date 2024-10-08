shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool flipX = false;
uniform bool flashingWhite = false;
uniform float currentXPosition = 0.0;

void fragment() {
	// mirror the image over the y axis if needed
	vec2 uv = SCREEN_UV;
	if (flipX) {
		uv.x = (currentXPosition * 2.0) - uv.x;
	}
	
	// compute the color
	vec4 c = textureLod(screen_texture, uv, 0.0);
	
	// output white if entity is flashing white
	if (flashingWhite) {
		c.rgb = vec3(1.0);
	}
	
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
	//COLOR = vec4(SCREEN_UV.x, SCREEN_UV.y, 1.0, 1.0);
}