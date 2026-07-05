// White hover outline for battlefield units (toggled from the initiative bar).
shader_type canvas_item;

uniform bool outline_on = false;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 col = tex * COLOR;
	if (outline_on && tex.a < 0.15) {
		vec2 px = TEXTURE_PIXEL_SIZE;
		float neighbor_a = texture(TEXTURE, UV + vec2(px.x, 0.0)).a
			+ texture(TEXTURE, UV - vec2(px.x, 0.0)).a
			+ texture(TEXTURE, UV + vec2(0.0, px.y)).a
			+ texture(TEXTURE, UV - vec2(0.0, px.y)).a;
		if (neighbor_a > 0.1) {
			col = vec4(1.0, 1.0, 1.0, 0.95);
		}
	}
	COLOR = col;
}
