shader_type spatial;

uniform vec3 cloud_color = vec3(1.0, 1.0, 1.0);
uniform vec3 sky_color = vec3(0.3, 0.6, 1.0);
uniform float cloud_cover = 0.5;
uniform float cloud_sharpness = 3.0;
uniform float scale = 1.0;
uniform sampler2D noise;

void fragment() {
	float cloud_noise = texture(noise, UV.xy).r;
	float cloud = smoothstep(cloud_cover - cloud_sharpness, cloud_cover + cloud_sharpness, cloud_noise);
	ALBEDO = mix(sky_color, cloud_color, cloud);
}
