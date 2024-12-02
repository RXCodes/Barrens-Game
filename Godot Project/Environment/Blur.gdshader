shader_type canvas_item;

uniform float lod: hint_range(0.0, 5) = 0.0;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment(){
	// get the color of the items rendering behind the element with blur
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	
	// mix the color and the element's color depending on alpha channel
	vec3 resultColor = mix(color.rgb, COLOR.rgb, COLOR.a);
	
	// set the resulting color
	COLOR.rgb = resultColor;
	COLOR.a = alpha;
}