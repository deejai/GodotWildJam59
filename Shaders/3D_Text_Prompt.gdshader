shader_type spatial;

void fragment() {
	ALBEDO = vec3(1.0 - 0.65 * UV.y, 1.0 - 0.65 * UV.y, 1.0 - 0.95 * UV.y);
}
