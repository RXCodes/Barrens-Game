shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// compute the color
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0);
	if (c.rgba == vec4(0.0, 0.0, 0.0, 1.0)) {
		c.rgb = vec3(1.0, 0.85, 0.3);
	} else {
		c.rgb = vec3(1.0, 1.0, 0.75);
	}
	
	if (c.a == 0.0) {
		float size = 15.0;
		float newAlpha = 0.0;
		for (float x = -size; x < size; x++) {
			float targetX = (x * SCREEN_PIXEL_SIZE.x);
			for (float y = -size; y < size; y++) {
				float targetY = (y * SCREEN_PIXEL_SIZE.y);
				vec2 target = vec2(targetX, targetY);
				newAlpha += textureLod(screen_texture, SCREEN_UV + target, 0.5).a;
			}
		}
		c.rgb = vec3(2.0, 2.0, 1.0);
		c.a = newAlpha / (size * size);
	}
	
	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}
	COLOR *= c;
}