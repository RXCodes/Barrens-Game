shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture;
uniform vec2 scrollAmount = vec2(0.05, 0.05);
uniform float multiplier : hint_range(0.0, 0.1) = 0.01;

void fragment() {
	vec2 distortionUV = SCREEN_UV + texture(TEXTURE, UV + scrollAmount * TIME).r * multiplier;
	vec4 screen = texture(screenTexture, distortionUV);
	COLOR = screen;
}