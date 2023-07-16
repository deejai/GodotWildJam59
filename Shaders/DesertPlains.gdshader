shader_type spatial;

uniform float scale = 10.0;
uniform float height = 2.0;
uniform vec3 color1 = vec3(0.7, 0.6, 0.45);
uniform vec3 color2 = vec3(0.9, 0.8, 0.7);
uniform sampler2D noise;

void vertex() {
	vec2 noise_coords = VERTEX.xz / scale;
	float noise_val = texture(noise, noise_coords).r;
	VERTEX.y += noise_val * height;
}

void fragment() {
	vec2 noise_coords = UV;
	float noise_val = max(0.35, texture(noise, noise_coords).r);
	vec3 color = mix(color1, color2, noise_val);
	ALBEDO = color;
}
