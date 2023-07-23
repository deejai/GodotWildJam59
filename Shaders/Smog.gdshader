shader_type spatial;

uniform sampler2D noise;

void fragment() {
	float dist_to_center_sq = (UV.x - 0.5) * (UV.x - 0.5) + (UV.y - 0.5) * (UV.y - 0.5);
	ALPHA = 0.2 - 2.0 * dist_to_center_sq;
	vec4 noise_val = texture(noise, vec2(UV.x, UV.y));
	ALBEDO = noise_val.rgb;
}
