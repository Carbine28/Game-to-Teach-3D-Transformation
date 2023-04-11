shader_type spatial;

uniform vec4 block_color: hint_color = vec4(255,255,255,1);


void fragment() {
	ALBEDO =  block_color.xyz;

}