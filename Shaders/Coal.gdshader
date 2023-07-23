shader_type spatial;

uniform sampler2D noise;
uniform float bumpiness = 0.1;

void vertex() {
	vec4 noise_val = texture(noise, UV);
	float displacement = noise_val.r * bumpiness;
	VERTEX += NORMAL * displacement;
}

void fragment() {
	vec4 noise_val = texture(noise, UV);
	ALBEDO = noise_val.rgb;
}
