shader_type spatial;

uniform sampler2D noise;
uniform float uv_x_scale = 2.69230769231; //3.5/1.3
uniform float offset_1 = 0.0;
uniform float height_scale_1 = 0.05;
uniform float bumpiness_freq_1 = 10.0;
uniform float offset_2 = 0.0;
uniform float height_scale_2 = 0.18;
uniform float bumpiness_freq_2 = 1.0;

void vertex() {
	float height_1 = height_scale_1 * (cos((offset_1 * PI) + UV.x * 2.0 * PI * bumpiness_freq_1) * sin((offset_1 * PI) + UV.y * 2.0 * PI * bumpiness_freq_1));
	float height_2 = height_scale_2 * (cos((offset_2 * PI) + UV.x * 2.0 * PI * bumpiness_freq_2) * sin((offset_2 * PI) + UV.y * 2.0 * PI * bumpiness_freq_2));
	float edge_modifier = 1.0 * min(UV.x, abs(1.0-UV.x)) * min(UV.y, abs(1.0-UV.y));
	float edge_curve = 0.0;
	if((abs(UV.y - 0.5) > 0.4)) {
		edge_curve = -.05 + 0.05 * cos(PI * (abs(UV.y - 0.5) - .4) / 0.2);
	}
	VERTEX.z = ((height_1 + height_2) + 0.5 * texture(noise, UV.xy).r) * edge_modifier + edge_curve;
}

void fragment() {
	ALBEDO = texture(noise, vec2(UV.x * uv_x_scale, UV.y)).rgb;
}
