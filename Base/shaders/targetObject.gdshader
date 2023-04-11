shader_type spatial;

uniform float _alpha: hint_range(0, 1) = .2;
uniform vec4 _color: hint_color = vec4(144,144,144,1);

void fragment(){
	ALBEDO = _color.xyz;
	ALPHA = _alpha;
}