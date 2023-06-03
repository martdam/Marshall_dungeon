shader_type canvas_item;

uniform bool hit = false;
uniform bool froze = false;
uniform vec4 color : hint_color;

void fragment()
{
	vec4 color_original= texture(TEXTURE,UV);
	
	if (hit){
		color_original.a *=  mod(TIME*2.5,0.8);
	}
	
	vec4 color_final  = color_original * color ;
	
	if(froze){
		color_final.rgb += mix(color_original.rgb,color.rgb,0.4);
	}
	
	COLOR = color_final;
}
