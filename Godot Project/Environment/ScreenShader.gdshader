shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment(){
	// get the color of the screen normally and with blur
	vec4 normalColor = texture(SCREEN_TEXTURE, SCREEN_UV, 0);
	vec4 blurColor = texture(SCREEN_TEXTURE, SCREEN_UV, 4);
	vec4 blurColor2 = texture(SCREEN_TEXTURE, SCREEN_UV, 8);
	
	vec4 resultColor = normalColor + (blurColor * 0.15);
	resultColor += blurColor2 * 0.1;
	resultColor.rgb *= 0.925;
	
	COLOR = resultColor;
}