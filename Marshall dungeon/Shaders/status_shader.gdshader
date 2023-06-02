shader_type canvas_item;

uniform int status = 0;
uniform vec4 color : hint_color;

void fragment()
{
	vec4 color_original= texture(TEXTURE,UV);
	vec4 color_final = color_original;
	COLOR = color_final;
}
