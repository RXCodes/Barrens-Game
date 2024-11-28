shader_type canvas_item;

uniform sampler2D dissolve_texture;
uniform float dissolve_value : hint_range(0,1);

void fragment(){
	// round UV to give pixelated look
	vec2 inputUV = UV;
	const float UVStep = 0.0025;
	inputUV /= UVStep;
	inputUV.x = round(inputUV.x);
	inputUV.y = round(inputUV.y);
	inputUV *= UVStep;
    vec4 main_texture = texture(TEXTURE, inputUV);
    vec4 noise_texture = texture(dissolve_texture, inputUV);
    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
	main_texture.a *= COLOR.a;
    COLOR = main_texture;
}