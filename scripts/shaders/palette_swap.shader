shader_type canvas_item;

uniform sampler2D palettes;
uniform int palette_n;

void fragment(){
	ivec2 coords = ivec2(vec2(textureSize(TEXTURE, 0)) * UV);
	vec4 base_col = texelFetch(TEXTURE, coords, 0);
	float index = floor(base_col.r*255.0);
	vec4 color = texelFetch(palettes, ivec2(int(index), palette_n), 0);
	color.a = texture(TEXTURE, UV).a;
	COLOR = color;
}
