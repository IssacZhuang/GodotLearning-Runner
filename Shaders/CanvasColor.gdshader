shader_type canvas_item;

uniform vec4 Color: source_color;

void vertex() {
	 VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 0.0)).xy;
}

void fragment() {
	COLOR = texture(TEXTURE, UV)*Color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
